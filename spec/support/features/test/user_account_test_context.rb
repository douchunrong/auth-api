shared_context 'user_account_test' do
  def create_user_accounts_for_for_test(token: nil, attrs_set: [{}])
    if token
        header 'Authorization', "Bearer #{token}"
    end
    post '/v1/test/user-accounts',
      { attrs_set: attrs_set }.to_json,
      'CONTENT_TYPE' => 'application/json'
  end

  def delete_user_account_for_test(token: nil, identifier:)
    if token
      header 'Authorization', "Bearer #{token}"
    end
    delete "/v1/test/user-accounts/#{identifier}"
  end

  def list_user_accounts_for_test(token: nil, **params)
    if token
      header 'Authorization', "Bearer #{token}"
    end
    get '/v1/test/user-accounts', params
  end

  def grant_access_token_for_test(identifier:, token: nil, scopes: [])
    if token
        header 'Authorization', "Bearer #{token}"
    end
    post "/v1/test/user-accounts/#{identifier}/tokens",
      { scopes: scopes }.to_json,
      'CONTENT_TYPE' => 'application/json'
  end

  def response_should_be_render_created_user_accounts
    expect(last_response.status).to eq(200)
    accounts_json = ActiveModel::SerializableResource.new(Account.createds).to_json
    expect(last_response.body).to be_json_eql(accounts_json)
  end

  def response_should_render_granted_access_token
    last_token = AccessToken.createds.last
    expect(last_response.status).to eq(200)
    expect(last_response.body).to be_json_eql(<<-JSON)
      {
        "access_token": "#{last_token.token}",
        "token_type": "Bearer"
      }
    JSON
    .excluding('expires_in')
    token_response = JSON.parse(last_response.body).transform_keys do |key|
      key.parameterize.underscore.to_sym
    end
    expect(token_response[:expires_in]).to be >= (last_token.expires_at - Time.now.utc).to_i
    token_response
  end

  def user_accounts_should_be_created(params)
    if params[:count]
      expect(Account.createds.size).to eq(params[:count])
    end
    attrs_set = params[:attrs_set]
    if attrs_set
      Account.createds.zip(attrs_set).each do |account, attrs|
        account_attrs = attrs.except :parti
        expect(account.attributes.symbolize_keys.slice(*account_attrs.keys)).to eq(account_attrs)
        parti_attrs = attrs[:parti]
        if parti_attrs
          actual_attrs = account.parti.user.attributes.symbolize_keys.slice(*parti_attrs.keys)
          expect(actual_attrs).to eq(parti_attrs.except(:password))
          if parti_attrs[:password]
            expect(account.parti.user.valid_password? parti_attrs[:password]).to be true
          end
        end
      end
    end
  end

  def user_account_should_be_deleted(attrs)
    parti_attrs = attrs[:parti]
    if parti_attrs
      accounts = UserAccount.joins(parti: :user).where(users: parti_attrs)
    else
      accounts = UserAccount.where(attrs)
    end
    expect(accounts).to be_empty
  end

  def response_should_render_user_accounts(accounts)
    expect(last_response.status).to eq(200)
    accounts_json = ActiveModel::SerializableResource.new(accounts).to_json
    expect(last_response.body).to be_json_eql(accounts_json)
  end
end
