shared_context 'auth' do
  def token_is_granted(params)
    access_token = params[:account].access_tokens.create(:client => params[:client])
    if params[:scope]
      access_token.scopes << Scope.where('name IN (?)', params[:scope].split)
    end
    access_token.token
  end

  def request_authorization_code(params)
    header 'uid', params[:user_auth_token][:uid]
    header 'access-token', params[:user_auth_token][:access_token]
    header 'client', params[:user_auth_token][:client]

    post '/v1/authorizations',
      client_id: params[:client_id],
      client_secret: params[:client_secret],
      nonce: params[:nonce],
      response_type: 'code',
      state: params[:state]
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

  def extract_authorization_params(url)
    uri = URI url
    Hash[URI::decode_www_form(uri.query)]
      .transform_keys { |key| key.parameterize.underscore.to_sym }
      .slice(:code, :state)
  end
end
