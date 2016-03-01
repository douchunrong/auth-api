require 'rails_helper.rb'

describe 'Create client' do
  it 'creates client' do
    user = user_exists
    token = token_is_granted_for user

    create_client(
      token: token,
      redirect_uris: ['http://redirect.uri']
    )

    client_should_be_created(
      user: user,
      redirect_uris: ['http://redirect.uri']
    )
  end
end
