require 'rails_helper.rb'

describe 'Client requests authorization code' do
  include_context 'feature'

  it 'grants authorization code' do
    accounts_not_exist(
      parti: { email: 'user@email.com' }
    )
    user_auth_token = user_auth_token_exists(
      email: 'user@email.com'
    )
    client = client_exists

    request_authorization_code(
      user_auth_token: user_auth_token,
      client_id: client.identifier,
      client_secret: client.secret,
      state: 'state-random',
      nonce: 'nonce-random'
    )

    authorization_code_should_be_granted(
      nonce: 'nonce-random',
      state: 'state-random'
    )
  end
end
