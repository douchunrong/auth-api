require 'rails_helper'

describe 'Create client' do
  include_context 'feature'

  let (:client) { auth_api_test_client }

  before :each do
    @account = user_account_exists
    @token = token_is_granted(
      account: @account,
      client: client,
      scope: Scope::CREATE_CLIENT
    )
  end

  it 'creates client' do
    create_client(
      token: @token,
      name: 'client_name',
      redirect_uris: ['http://redirect.uri']
    )

    response_should_render_created_client
    client_should_be_created(
      user_account: @account,
      name: 'client-name',
      redirect_uris: ['http://redirect.uri']
    )
  end

  it 'responds 400 bad request without name' do
    create_client(
      token: @token,
      redirect_uris: ['http://redirect.uri']
    )

    response_should_be_400_bad_request
  end

  it 'responds 400 bad request with empty redirect_uris' do
    create_client(
      token: @token,
      name: 'client-name',
      redirect_uris: []
    )

    response_should_be_400_bad_request
  end

  it 'responds 400 bad request with string redirect_uris' do
    create_client(
      token: @token,
      name: 'client-name',
      redirect_uris: 'http://redirect.url'
    )

    response_should_be_400_bad_request
  end

  it 'responds 400 bad request without redirect_uris' do
    create_client(
      token: @token,
      name: 'client-name'
    )

    response_should_be_400_bad_request
  end

  it 'responds 401 unauthorized without token' do
    create_client(
      name: 'client-name',
      redirect_uris: ['http://redirect.uri']
    )

    response_should_be_401_unauthorized
  end
end
