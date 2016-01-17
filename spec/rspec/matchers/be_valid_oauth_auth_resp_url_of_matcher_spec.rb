describe 'be_valid_oauth_auth_resp_url_of' do
  it 'passes with valid response' do
    req_url = URI.parse('http://auth-server.com/auth-endpoint')
    req_url.query = URI.encode_www_form(
      client_id: 'client-id',
      nonce: 'nonce-random',
      redirect_uri: 'http://client.com/callback',
      response_type: 'code',
      scope: 'openid profile email address',
      state: 'state-random'
    )

    resp_url = URI.parse('http://client.com/callback')
    resp_url.query = URI.encode_www_form(
      code: 'auth-code',
      state: 'state-random'
    )
    expect(resp_url.to_s).to be_valid_oauth_auth_resp_url_of(req_url.to_s)
  end
end
