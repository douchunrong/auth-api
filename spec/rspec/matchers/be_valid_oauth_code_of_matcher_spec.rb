describe 'be_valid_oauth_code_of' do
  include_context 'authorization'

  let(:auth) { 
    authorizations_exist(
      { scopes: [ 'openid', 'email' ] }
    ).first
  }
  let(:req_params) {
    {
      client_id: auth.client.identifier,
      nonce: auth.nonce,
      redirect_uri: auth.redirect_uri,
      scope: 'openid email'
    }
  }

  it 'passes with valid code' do
    expect(auth.code).to be_valid_oauth_code_of(req_params)
  end

  it 'passes with empty scope' do
    auth_with_empty_scope, * = authorizations_exist scopes: []
    req_params_with_empty_scope = {
      client_id: auth_with_empty_scope.client.identifier,
      nonce: auth_with_empty_scope.nonce,
      redirect_uri: auth_with_empty_scope.redirect_uri,
      scope: ''
    }
    expect(auth_with_empty_scope.code).to be_valid_oauth_code_of(req_params_with_empty_scope)
  end

  it 'does not pass with wrong client_id' do
    req_params[:client_id] += '-wrong'
    expect(auth.code).to_not be_valid_oauth_code_of(req_params)
  end

  it 'does not pass with wrong nonce' do
    req_params[:nonce] += '-wrong'
    expect(auth.code).to_not be_valid_oauth_code_of(req_params)
  end

  it 'does not pass with wrong redirect_uri' do
    req_params[:redirect_uri] += '-wrong'
    expect(auth.code).to_not be_valid_oauth_code_of(req_params)
  end

  it 'does not pass with different to request scope' do
    req_params[:scope] = scope_different(req_params[:scope])
    expect(auth.code).to_not be_valid_oauth_code_of(req_params)
  end

  private

  def scope_different(scope_str)
    scopes = scope_str.split(' ')
    if scopes.empty?
      scopes.push('openid')
    else
      scopes.pop
    end
    scopes.join('')
  end
end
