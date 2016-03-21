shared_context 'authorization' do
  include TokenHelper

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

  def authorization_code_should_not_be_granted
    expect(Authorization.createds).to be_empty
  end

  def extract_authorization_params(url)
    uri = URI url
    Hash[URI::decode_www_form(uri.query)]
      .transform_keys { |key| key.parameterize.underscore.to_sym }
      .slice(:code, :state)
  end
end
