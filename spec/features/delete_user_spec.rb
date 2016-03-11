require 'rails_helper.rb'

describe 'delete user' do
  include_context 'feature'

  it 'deletes user' do
    client = client_exists
    token = token_is_granted_by_client_credentials client: client
    user = user_exists email: 'user@email.com'

    delete_user(
      token: token,
      user_id: user.id
    )

    response_should_be_204_no_content
    user_should_be_deleted email: 'user@email.com'
  end

  it 'respond 401 unauthorized without token' do
    user = user_exists email: 'user@email.com'

    delete_user user_id: user.id

    response_should_be_401_unauthorized
  end
end
