require 'rails_helper.rb'

describe 'create user account for test' do
  include_context 'feature'

  it 'create a user account without params' do
    client = client_exists
    token = token_is_granted_by_client_credentials client: client
    ApplicationRecordTest.clear_createds

    create_user_accounts_for_for_test token: token

    response_should_be_render_created_user_accounts
    user_accounts_should_be_created count: 1
  end

  it 'create user accounts with parti identifier' do
    client = client_exists
    token = token_is_granted_by_client_credentials client: client
    ApplicationRecordTest.clear_createds

    create_user_accounts_for_for_test(
      token: token,
      attrs_set: [
        { parti: { identifier: 'identifier-1' }},
        { parti: { identifier: 'identifier-2' }}
      ]
    )

    response_should_be_render_created_user_accounts
    user_accounts_should_be_created(
      attrs_set: [
        { parti: { identifier: 'identifier-1' }},
        { parti: { identifier: 'identifier-2' }}
      ]
    )
  end
end
