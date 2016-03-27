require 'rails_helper'

describe 'Create client' do
  include_context 'feature'

  it 'creates client' do
    account = user_account_exists
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
      user_account: account,
      name: 'client_name',
      redirect_uris: ['http://redirect.uri']
    )
  end

  it 'responds 400 bad request without name' do
    account = user_account_exists
    client = auth_api_test_client
    token = token_is_granted(
      account: account,
      client: client,
      scope: Scope::CREATE_CLIENT
    )

    create_client(
      token: token,
      redirect_uris: ['http://redirect.uri']
    )

    response_should_be_400_bad_request
  end
end
