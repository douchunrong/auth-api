require 'rails_helper.rb'

describe 'Delete test account' do
  include_context 'feature'

  it 'deletes all test account of client' do
    client = client_exists
    test_account_exists client: client
    token = token_is_granted_by_client_credentials client: client

    delete_all_test_accounts(
      token: token.token,
      client_id: client.identifier
    )

    response_should_be_204_no_content
    all_test_accounts_should_be_deleted client: client
  end

  it 'respond 401 unauthorized with another client\'s token' do
    client, another_client = clients_exist count: 2
    test_account_exists client: client
    another_token = token_is_granted_by_client_credentials client: another_client

    delete_all_test_accounts(
      token: another_token.token,
      client_id: client.identifier
    )

    response_should_be_401_unauthorized
  end

  it 'respond 401 unauthorized without token' do
    client = client_exists

    delete_all_test_accounts(
      client_id: client.identifier
    )

    response_should_be_401_unauthorized
  end

  it 'respond 404 not found with client does not exist' do
    client = client_exists
    token = token_is_granted_by_client_credentials client: client

    delete_all_test_accounts(
      token: token.token,
      client_id: 'client-id-not-exist'
    )
    response_should_be_404_not_found
  end
end
