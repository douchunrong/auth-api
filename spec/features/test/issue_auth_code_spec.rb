require 'rails_helper'

describe 'issue auth code for test' do
  include_context 'feature'

  it 'issues authorization code' do
    client = client_exists
    token = token_is_granted_by_client_credentials client: client
    audience = client_exists redirect_uris: ['http://redirect-uri.com']

    issue_auth_code_for_test(
      account: { parti: { identifier: 'user-identifier' } },
      client_id: audience.identifier,
      nonce: 'random-nonce',
      redirect_uri: 'http://redirect-uri.com',
      scopes: [ Scope::OPENID ],
      token: token.token
    )

    response = auth_code_should_be_rendered

    account = ConnectParti.find_by_identifier!('user-identifier').account
    expect(account).to be_present

    auth_code_should_be_issued(
      account: account,
      client: audience,
      code: response[:code],
      nonce: 'random-nonce',
      redirect_uri: 'http://redirect-uri.com',
      scopes: [ Scope::OPENID ]
    )
  end
end
