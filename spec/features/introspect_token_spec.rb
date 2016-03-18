require 'rails_helper.rb'

describe 'Introspect token' do
  include_context 'feature'

  before :each do
    @client = client_exists
    @token = access_token_is_granted(
      account: @client.user_account,
      client: @client
    )
  end

  it 'introspects active access_token with same access_token' do
    introspect_token(
      target_token: @token.token,
      access_token: @token.token
    )

    response_should_render_token_introspection token: @token
  end

  it 'responds that active is false with another access_token' do
    another_token = access_token_is_granted(
      account: @client.user_account,
      client: @client
    )

    introspect_token(
      target_token: @token.token,
      access_token: another_token.token
    )

    response_should_render_inactive_introspection
  end

  it 'responds that active is false with token does not exist' do
    introspect_token(
      target_token: 'not-exist-token',
      access_token: @token.token
    )

    response_should_render_inactive_introspection
  end

  it 'responds 401 unauthorized with expired access_token' do
    @token.expires_at = 1.second.ago
    @token.save!

    introspect_token(
      target_token: @token.token,
      access_token: @token.token
    )

    response_should_be_401_unauthorized
  end

  it 'responds 401 unauthorized without access_token' do
    introspect_token(
      target_token: @token.token
    )

    response_should_be_401_unauthorized
  end

  it 'responds 401 unauthorized with access_token does not exist' do
    introspect_token(
      target_token: @token.token,
      access_token: 'not-exist-access-token'
    )

    response_should_be_401_unauthorized
  end
end
