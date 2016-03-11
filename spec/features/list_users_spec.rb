require 'rails_helper.rb'

describe 'list users' do
  include_context 'feature'

  it 'lists user by email' do
    client = client_exists
    token = token_is_granted_by_client_credentials client: client
    wally = user_exists email: 'wally@email.com'

    list_users(
      email: 'wally@email.com',
      token: token
    )

    response_should_render_users [ wally ]
  end

  it 'lists empty with email not exists' do
    client = client_exists
    token = token_is_granted_by_client_credentials client: client
    user_not_exist email: 'wally@email.com'

    list_users(
      email: 'wally@email.com',
      token: token
    )

    response_should_render_users []
  end

  it 'responds 401 unauthorized without token' do
    user_not_exist email: 'wally@email.com'

    list_users email: 'wally@email.com'

    response_should_be_401_unauthorized
  end
end
