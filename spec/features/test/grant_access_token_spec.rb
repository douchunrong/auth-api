require 'rails_helper.rb'

describe 'grant access_token for test' do
  include_context 'feature'

  it 'grant account_token' do
    client = client_exists
    token = token_is_granted_by_client_credentials client: client
    account = user_account_exists

    grant_access_token_for_test(
      identifier: account.identifier,
      scopes: [ Scope::CREATE_CLIENT ],
      token: token
    )

    response = response_should_render_granted_access_token
    access_token_should_be_granted(
      access_token: response[:access_token],
      account: account,
      client: client,
      scopes: [ Scope::CREATE_CLIENT ]
    )
  end

  it 'responds 401 without token' do
    account = user_account_exists

    grant_access_token_for_test(
      identifier: account.identifier,
      scopes: [ Scope::CREATE_CLIENT ]
    )
    response_should_be_401_unauthorized
  end
end
