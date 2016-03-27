shared_context 'authorization' do
  include TokenHelper

  def authorization_code_is_granted(params)
    account = params[:account]
    auth_params = params.slice :client, :nonce, :redirect_uri
    unless auth_params[:redirect_uri]
      auth_params[:redirect_uri] = auth_params[:client].redirect_uris.first
    end
    authorization = account.authorizations.create! auth_params
    if params[:scopes]
      authorization.scopes << params[:scopes].map{ |s| Scope.find_by_name! s }
    end
    authorization
  end

  def request_authorization_code(params)
    if params[:user_token]
      header 'uid', params[:user_token][:uid]
      header 'access-token', params[:user_token][:access_token]
      header 'client', params[:user_token][:client]
    end

    data = { response_type: 'code' }
    .merge params.slice(:client_id, :nonce, :state)
    .merge params.slice(:scopes).map{ |k,v| [ :scope, v.respond_to?(:join) ? v.join(' ') : v ] }.to_h

    post '/v1/authorizations', data
  end

  def authorization_code_should_be_granted(params)
    expect(last_response).to be_redirect
    auth_params = extract_authorization_params(last_response.headers['Location'])
    expect(auth_params[:state]).to eq(params[:state])

    authorization_code_should_be_valid(
      auth_params.slice(:code).merge params.slice(:nonce, :scopes)
    )
  end

  def authorization_code_should_be_valid(params)
    authorization = Authorization.valid.find_by_code params[:code]
    expect(authorization).not_to be_nil
    expect(authorization.nonce).to eq(params[:nonce])
    if params[:scopes]
      expect(authorization.scopes.map(&:name)).to match_array(params[:scopes])
    end
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
