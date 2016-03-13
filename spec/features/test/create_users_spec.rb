require 'rails_helper.rb'

describe 'create users for test' do
  include_context 'feature'

  it 'create a user without params' do
    client = client_exists
    token = token_is_granted_by_client_credentials client: client
    ApplicationRecordTest.clear_createds

    create_users_for_for_test token: token

    response_should_be_render_created_users
    users_should_be_created count: 1
  end

  it 'create users with email attrs' do
    client = client_exists
    token = token_is_granted_by_client_credentials client: client
    ApplicationRecordTest.clear_createds

    create_users_for_for_test(
      token: token,
      attrs_set: [
        { email: 'one@email.com' },
        { email: 'two@email.com' }
      ]
    )

    response_should_be_render_created_users
    users_should_be_created(
      attrs_set: [
        { email: 'one@email.com' },
        { email: 'two@email.com' }
      ]
    )
  end
end
