require 'rails_helper.rb'

shared_examples 'grant authorization code' do
  include_context 'feature'

  it 'grants authorization code' do
    request_authorization_code(
      user_auth_token: @user_auth_token,
      client_id: @client.identifier,
      state: 'state-random',
      nonce: 'nonce-random'
    )

    authorization_code_should_be_granted(
      nonce: 'nonce-random',
      state: 'state-random'
    )
  end

  it 'responds 401 unauthorized without user auth token' do
    request_authorization_code(
      client_id: @client.identifier,
      state: 'state-random',
      nonce: 'nonce-random'
    )

    response_should_be_401_unauthorized
    authorization_code_should_not_be_granted
  end

  it 'responds 400 bad request without client_id' do
    request_authorization_code(
      user_auth_token: @user_auth_token,
      state: 'state-random',
      nonce: 'nonce-random'
    )

    response_should_be_400_bad_request
    authorization_code_should_not_be_granted
  end
end

describe 'Request authorization code' do
  include_context 'feature'

  before :each do
    @client = client_exists
  end

  context 'user account does not exist' do
    before :each do
      user_accounts_not_exist parti: { email: 'user@email.com' }
      user_exists email: 'user@email.com', password: 'Passw0rd!'
      @user_auth_token = user_auth_token_exists(
        email: 'user@email.com',
        password: 'Passw0rd!'
      )
    end

    include_examples 'grant authorization code'
  end

  context 'user account exists' do
    before :each do
      user_account_exists parti: { email: 'user@email.com', password: 'Passw0rd!' }
      @user_auth_token = user_auth_token_exists(
        email: 'user@email.com',
        password: 'Passw0rd!'
      )
    end

    include_examples 'grant authorization code'
  end
end
