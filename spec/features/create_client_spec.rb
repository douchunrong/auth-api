require 'rails_helper.rb'

describe 'Create client' do
  include_context 'feature'

  it 'creates client' do
    account = account_exists
    client = auth_api_test_client
    token = token_is_granted(
      account: account,
      client: client,
      scope: Scope::CREATE_CLIENT
    )

    create_client(
      token: token,
      name: 'client_name',
      redirect_uris: ['http://redirect.uri']
    )

    response_should_render_created_client
    client_should_be_created(
      account: account,
      name: 'client_name',
      redirect_uris: ['http://redirect.uri']
    )
  end
end
