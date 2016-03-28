require 'rails_helper.rb'

describe 'Create test account' do
  include_context 'feature'

  it 'creates test account' do
    client = client_exists
    token = token_is_granted_by_client_credentials client: client

    create_test_account(
      token: token.token,
      client: client
    )

    response_should_render_test_account
    test_account_should_be_created client: client
  end

  it 'responds 401 unauthorized creating test account for another client' do
    client, another_client = clients_exist count: 2
    token = token_is_granted_by_client_credentials client: client

    create_test_account(
      token: token.token,
      client: another_client
    )

    response_should_be_401_unauthorized
  end

  it 'responds 401 unauthorized without token' do
    client = client_exists

    create_test_account(
      client: client
    )

    response_should_be_401_unauthorized
  end
end
