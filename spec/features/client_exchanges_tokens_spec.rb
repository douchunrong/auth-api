require 'rails_helper.rb'

describe 'Client exchanges tokens' do
  include_context 'feature'

  it 'grants tokens' do
    account = account_exists
    client = client_exists
    authorization = authorization_code_is_granted(
      account: account,
      client: client,
      scope: 'openid',
      nonce: 'nonce-random'
    )

    exchange_tokens(
      client_id: client.identifier,
      client_secret: client.secret,
      code: authorization.code,
      redirect_uri: authorization.redirect_uri,
      scope: Scope::OPENID
    )

    response = response_should_render_tokens
    tokens_should_be_granted(
      access_token: response[:access_token],
      account: account,
      client: client,
      id_token: response[:id_token],
      nonce: 'nonce-random',
      scope: Scope::OPENID
    )
  end
end
