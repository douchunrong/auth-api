require 'rails_helper.rb'

describe 'delete user_account for test' do
  include_context 'feature'

  it 'deletes user_account' do
    client = client_exists
    token = token_is_granted_by_client_credentials client: client
    account = user_account_exists parti: { identifier: 'parti-identifier' }

    delete_user_account_for_test(
      identifier: account.identifier,
      token: token.token
    )

    response_should_be_204_no_content
    user_account_should_be_deleted parti: { identifier: 'parti-identifier' }
    user_account_should_be_deleted id: account.id
  end

  it 'respond 401 unauthorized without token' do
    account = user_account_exists

    delete_user_account_for_test identifier: account.identifier

    response_should_be_401_unauthorized
  end
end
