shared_context 'token' do
  include TokenHelper
  include_context 'rack_test'

  def token_is_granted(params)
    access_token = params[:account].access_tokens.create(:client => params[:client])
    if params[:scope]
      access_token.scopes << Scope.where('name IN (?)', params[:scope].split)
    end
    access_token.token
  end

  def access_token_is_granted(account:, client:, scopes: [])
    access_token = account.access_tokens.build client: client
    access_token.scopes << Scope.where('name IN (?)', scopes)
    access_token.save!
    access_token
  end

  def token_is_granted_by_client_credentials(client:)
    exchange_client_credentials_for_token(
      client_id: client.identifier,
      client_secret: client.secret
    )
    expect(last_response.status).to eq(200)
    token_response = JSON.parse(last_response.body).with_indifferent_access
    AccessToken.find_by_token! token_response[:access_token]
  end

  def exchange_tokens(params)
    cred = basic_auth_credential params[:client_id], params[:client_secret]
    header 'Authorization', "Basic #{cred}"
    post '/v1/tokens',
      code: params[:code],
      grant_type: 'authorization_code',
      redirect_uri: params[:redirect_uri]
  end

  def exchange_client_credentials_for_token(client_id:, client_secret:)
    cred = basic_auth_credential client_id, client_secret
    header 'Authorization', "Basic #{cred}"
    post '/v1/tokens', grant_type: 'client_credentials'
  end

  def exchange_client_credentials_for_token_without_credential
    post '/v1/tokens', grant_type: 'client_credentials'
  end

  def introspect_token(target_token:, access_token: nil)
    header 'Authorization', "Bearer #{access_token}"
    post '/v1/introspect', token: target_token
  end

  def response_should_render_tokens
    expect(last_response.status).to eq(200)
    token_response = JSON.parse(last_response.body).transform_keys do |key|
      key.parameterize.underscore.to_sym
    end
    expect(token_response[:access_token]).to be_present
    expect(token_response[:token_type]).to be_present
    expect(token_response[:expires_in]).to be_present
    expect(token_response[:id_token]).to be_present
    token_response
  end

  def response_should_render_access_token
    expect(last_response.status).to eq(200)
    token_response = JSON.parse(last_response.body).transform_keys do |key|
      key.parameterize.underscore.to_sym
    end
    expect(token_response[:access_token]).to be_present
    expect(token_response[:token_type]).to be_present
    expect(token_response[:expires_in]).to be_present
    token_response
  end

  def token_introspection_should_be_rendered(token:)
    response_should_be_200_ok_json
    expect(token.account).not_to be_kind_of NullAccount
    expect(last_response.body).to be_json_eql(<<-JSON)
      {
        "active": #{token.expires_at >= Time.now.utc ? 'true' : 'false'},
        "connect_id": "#{token.account.connect_id}",
        "connect_type": "#{token.account.connect_type}",
        "exp": #{token.expires_at.to_i},
        "grant_type": "authorization_code",
        "scope": "#{token.scopes.map(&:name).join(' ')}",
        "sub": "#{token.account.identifier}",
        "token_type": "bearer"
      }
    JSON
  end

  def client_credentials_token_introspection_should_be_rendered(token:)
    response_should_be_200_ok_json
    expect(token.account).to be_kind_of NullAccount
    expect(last_response.body).to be_json_eql(<<-JSON)
      {
        "active": #{token.expires_at >= Time.now.utc ? 'true' : 'false'},
        "exp": #{token.expires_at.to_i},
        "grant_type": "client_credentials",
        "scope": "#{token.scopes.map(&:name).join(' ')}",
        "sub": "#{token.client.identifier}",
        "token_type": "bearer"
      }
    JSON
  end

  def inactive_introspection_should_be_rendered
    response_should_be_200_ok_json
    expect(last_response.body).to be_json_eql(<<-JSON)
      {
        "active": false
      }
    JSON
  end

  def tokens_should_be_granted(params)
    access_token = AccessToken.valid.find_by! token: params[:access_token]
    expect(access_token).to be_present
    expect(access_token.scopes.pluck(:name)).to include(*params[:scope].split)
    expect(access_token.client).to eq(params[:client])
    expect(access_token.account).to eq(params[:account])

    id_token = IdToken.decode params[:id_token]
    expect(id_token.aud).to eq(params[:client].identifier)
    expect(id_token.email).to eq(params[:email])
    expect(id_token.exp.to_i).to be > Time.now.to_i
    expect(id_token.iss).to eq(IdToken.config[:issuer])
    expect(id_token.nonce).to eq(params[:nonce])
    expect(id_token.sub).to eq(params[:account].identifier)
  end

  def access_token_should_be_granted(access_token:, **options)
    token = AccessToken.valid.find_by! token: access_token
    expect(token.expires_at).to be > Time.now
    if options[:account]
      expect(token.account).to eq(options[:account])
    end
    if options[:client]
      expect(token.client).to eq(options[:client])
    end
    if options[:scopes]
      expect(token.scopes).to eq(options[:scopes].map { |s| Scope.find_by_name! s })
    end
  end
end
