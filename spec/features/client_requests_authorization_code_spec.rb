require 'rails_helper.rb'

shared_examples 'grant authorization code' do |email|
  include_context 'feature'

  it 'grants authorization code' do
    user_auth_token = user_auth_token_exists(
      email: email
    )

    request_authorization_code(
      user_auth_token: user_auth_token,
      client_id: @client.identifier,
      client_secret: @client.secret,
      state: 'state-random',
      nonce: 'nonce-random'
    )

    authorization_code_should_be_granted(
      nonce: 'nonce-random',
      state: 'state-random'
    )
  end
end

describe 'Client requests authorization code' do
  include_context 'feature'

  before :each do
    @client = client_exists
  end

  context 'account does not exist' do
    before :each do
      accounts_not_exist(
        parti: { email: 'user@email.com' }
      )
    end

    include_examples 'grant authorization code', 'user@email.com'
  end

  context 'account exists' do
    before :each do
      account_exists(
        parti: { email: 'user@email.com' }
      )
    end

    include_examples 'grant authorization code', 'user@email.com'
  end

  it 'responds 401 unauthorized without user auth token' do
    request_authorization_code(
      client_id: @client.identifier,
      client_secret: @client.secret,
      state: 'state-random',
      nonce: 'nonce-random'
    )

    response_should_be_401_unauthorized
    authorization_code_should_not_be_granted
  end

  it 'responds 401 unauthorized without client_id' do
    request_authorization_code(
      client_secret: @client.secret,
      state: 'state-random',
      nonce: 'nonce-random'
    )

    response_should_be_401_unauthorized
    authorization_code_should_not_be_granted
  end

  it 'responds 401 unauthorized without client_secret' do
    request_authorization_code(
      client_id: @client.identifier,
      state: 'state-random',
      nonce: 'nonce-random'
    )

    response_should_be_401_unauthorized
    authorization_code_should_not_be_granted
  end
end
