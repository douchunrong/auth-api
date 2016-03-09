shared_context 'auth' do
  def token_is_granted(params)
    access_token = params[:account].access_tokens.create(:client => params[:client])
    if params[:scope]
      access_token.scopes << Scope.where('name IN (?)', params[:scope].split)
    end
    access_token.token
  end

  def token_is_granted_by_client_credentials(client:)
    exchange_client_credentials_for_token(
      client_id: client.identifier,
      client_secret: client.secret
    )
    expect(last_response.status).to eq(200)
    token_response = JSON.parse(last_response.body).transform_keys do |key|
      key.parameterize.underscore.to_sym
    end
    token_response[:access_token]
  end

  def authorization_code_is_granted(params)
    account = params[:account]
    auth_params = params.slice :client, :nonce, :redirect_uri
    unless auth_params[:redirect_uri]
      auth_params[:redirect_uri] = auth_params[:client].redirect_uris.first
    end
    authorization = account.authorizations.create! auth_params
    if params[:scope]
      scopes = params[:scope].split.map do |name|
        Scope.find_by_name!(name)
      end
      authorization.scopes << scopes
    end
    authorization
  end

  def request_authorization_code(params)
    if params[:user_auth_token]
      header 'uid', params[:user_auth_token][:uid]
      header 'access-token', params[:user_auth_token][:access_token]
      header 'client', params[:user_auth_token][:client]
    end

    post '/v1/authorizations',
      client_id: params[:client_id],
      client_secret: params[:client_secret],
      nonce: params[:nonce],
      response_type: 'code',
      state: params[:state]
  end

  def basic_auth_credential(id, secret)
    ["#{id}:#{secret}"].pack('m').tr("\n", '')
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

  def authorization_code_should_be_granted(params)
    expect(last_response).to be_redirect
    auth_params = extract_authorization_params(last_response.headers['Location'])
    expect(auth_params[:state]).to eq(params[:state])
    authorization_code_should_be_valid(
      code: auth_params[:code],
      nonce: params[:nonce]
    )
  end

  def authorization_code_should_be_valid(params)
    authorization = Authorization.valid.find_by_code params[:code]
    expect(authorization).not_to be_nil
    expect(authorization.nonce).to eq(params[:nonce])
  end

  def authorization_code_should_not_be_granted
    expect(Authorization.last_created).to be_nil
  end

  def extract_authorization_params(url)
    uri = URI url
    Hash[URI::decode_www_form(uri.query)]
      .transform_keys { |key| key.parameterize.underscore.to_sym }
      .slice(:code, :state)
  end

  def tokens_should_be_granted(params)
    access_token = AccessToken.valid.find_by! token: params[:access_token]
    expect(access_token).to be_present
    expect(access_token.scopes.pluck(:name)).to include(*params[:scope].split)
    expect(access_token.client).to eq(params[:client])
    expect(access_token.account).to eq(params[:account])

    id_token = IdToken.decode params[:id_token]
    expect(id_token.aud).to eq(params[:client].identifier)
    expect(id_token.exp.to_i).to be > Time.now.to_i
    expect(id_token.iss).to eq(IdToken.config[:issuer])
    expect(id_token.nonce).to eq(params[:nonce])
    expect(id_token.sub).to eq(params[:account].identifier)
  end

  def access_tokens_should_be_granted(access_token:, client:)
    access_token = AccessToken.valid.find_by! token: access_token
    expect(access_token.client).to eq(client)
    expect(access_token.account).to eq(NullAccount.take)
    expect(access_token.expires_at).to be > Time.now
  end
end
