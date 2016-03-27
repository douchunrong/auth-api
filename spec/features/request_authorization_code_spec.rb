require 'rails_helper.rb'

shared_examples 'grant authorization code' do
  include_context 'feature'

  it 'grants authorization code' do
    request_authorization_code(
      client_id: @client.identifier,
      nonce: 'nonce-random',
      scopes: [Scope::OPENID],
      state: 'state-random',
      user_token: @user_token
    )

    authorization_code_should_be_granted(
      nonce: 'nonce-random',
      state: 'state-random',
      scopes: [Scope::OPENID]
    )
  end

  it 'responds 401 unauthorized without user token' do
    request_authorization_code(
      client_id: @client.identifier,
      state: 'state-random',
      nonce: 'nonce-random'
    )

    response_should_be_401_unauthorized
    authorization_code_should_not_be_granted
  end

  it 'responds 400 bad request  with wrong access-token' do
    @user_token['access-token'] =  'wrong-accesss-token'
    request_authorization_code(
      user_token: @user_token,
      state: 'state-random',
      nonce: 'nonce-random'
    )

    response_should_be_400_bad_request
    authorization_code_should_not_be_granted
  end

  it 'responds 400 bad request  without access-token' do
    @user_token.delete 'access-token'
    request_authorization_code(
      user_token: @user_token,
      state: 'state-random',
      nonce: 'nonce-random'
    )

    response_should_be_400_bad_request
    authorization_code_should_not_be_granted
  end

  it 'responds 400 bad request with wrong client_id' do
    @user_token[:client_id] = 'wrong_client_id'
    request_authorization_code(
      user_token: @user_token,
      state: 'state-random',
      nonce: 'nonce-random'
    )

    response_should_be_400_bad_request
    authorization_code_should_not_be_granted
  end

  it 'responds 400 bad request without client_id' do
    @user_token.delete 'client_id'
    request_authorization_code(
      user_token: @user_token,
      state: 'state-random',
      nonce: 'nonce-random'
    )

    response_should_be_400_bad_request
    authorization_code_should_not_be_granted
  end

  it 'responds 400 bad request with wrong uid' do
    @user_token['uid'] =  'wrong-uid'
    request_authorization_code(
      user_token: @user_token,
      state: 'state-random',
      nonce: 'nonce-random'
    )

    response_should_be_400_bad_request
    authorization_code_should_not_be_granted
  end

  it 'responds 400 bad request without uid' do
    @user_token.delete 'uid'
    request_authorization_code(
      user_token: @user_token,
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
      user_accounts_not_exist parti: { identifier: 'parti-identifier' }
      @user_token = user_token_exists(
        identifier: 'parti-identifier'
      )
    end

    include_examples 'grant authorization code'
  end

  context 'user account exists' do
    before :each do
      user_account_exists parti: { identifier: 'parti-identifier' }
      @user_token = user_token_exists identifier: 'parti-identifier'
    end

    include_examples 'grant authorization code'
  end
end
