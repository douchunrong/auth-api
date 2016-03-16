shared_context 'user_account_test' do
  def create_user_accounts_for_for_test(token: nil, attrs_set: [{}])
    if token
        header 'Authorization', "Bearer #{token}"
    end
    post "/v1/test/user-accounts",
      { attrs_set: attrs_set }.to_json,
      'CONTENT_TYPE' => 'application/json'
  end

  def response_should_be_render_created_user_accounts
    expect(last_response.status).to eq(200)
    accounts_json = ActiveModel::SerializableResource.new(Account.createds).to_json
    expect(last_response.body).to be_json_eql(accounts_json)
  end

  def user_accounts_should_be_created(params)
    if params[:count]
      expect(Account.createds.size).to eq(params[:count])
    end
    if params[:attrs_set]
      Account.createds.zip(params[:attrs_set]).each do |account, attrs|
        account_attrs = attrs.except :parti
        expect(account.attributes.symbolize_keys.slice(*account_attrs.keys)).to eq(account_attrs)
        parti_attrs = attrs[:parti]
        if parti_attrs
          expect(account.parti.user.attributes.symbolize_keys.slice(*parti_attrs.keys)).to eq(parti_attrs)
        end
      end
    end
  end

  def response_should_render_user_accounts(accounts)
    expect(last_response.status).to eq(200)
    accounts_json = ActiveModel::SerializableResource.new(accounts).to_json
    expect(last_response.body).to be_json_eql(accounts_json)
  end
end
