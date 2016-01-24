shared_context 'token' do
  def request_token(authorization)
    client = authorization[:client]
    cred = ["#{client.identifier}:#{client.secret}"].pack('m').tr("\n", '')
    header  'Authorization', "Basic #{cred}"
    post access_tokens_path(
      grant_type: 'authorization_code',
      code: authorization[:code],
      redirect_uri: client.redirect_uris.first
    )
  end

  def token_should_be_received
    expect(last_response).to be_ok
    resp = JSON.parse(last_response.body)
    expect(resp['access_token']).not_to be_blank
    expect(resp['id_token']).not_to be_blank
    expect(resp['expires_in']).not_to be_blank
    expect(resp['token_type']).to eq('bearer')
  end

  def token_is_granted_for(authorization)
    request_token authorization
    expect(last_response).to be_ok
    JSON.parse(last_response.body)
      .symbolize_keys
  end
end
