require 'rails_helper.rb'

describe 'Client exchanges tokens' do
  include_context 'feature'

  before :each do
    @account = account_exists
    @client = client_exists
    @authorization = authorization_code_is_granted(
      account: @account,
      client: @client,
      scope: Scope::OPENID,
      nonce: 'nonce-random'
    )
  end

  it 'grants tokens' do
    exchange_tokens(
      client_id: @client.identifier,
      client_secret: @client.secret,
      code: @authorization.code,
      redirect_uri: @authorization.redirect_uri,
    )

    response = response_should_render_tokens
    tokens_should_be_granted(
      access_token: response[:access_token],
      account: @account,
      client: @client,
      id_token: response[:id_token],
      nonce: 'nonce-random',
      scope: Scope::OPENID
    )
  end

  it 'responds 400 bad request without client id' do
    exchange_tokens(
      client_secret: @client.secret,
      code: @authorization.code,
      redirect_uri: @authorization.redirect_uri
    )
    response_should_be_400_bad_request
  end

  it 'responds 401 unauthorized with not existing client id' do
    exchange_tokens(
      client_id: 'not-existing-client-id',
      client_secret: @client.secret,
      code: @authorization.code,
      redirect_uri: @authorization.redirect_uri
    )
    response_should_be_401_unauthorized
  end

  it 'responds 401 unauthorized without client secret' do
    exchange_tokens(
      client_id: @client.identifier,
      code: @authorization.code,
      redirect_uri: @authorization.redirect_uri
    )
    response_should_be_401_unauthorized
  end

  it 'responds 401 unauthorized with wrong client secret' do
    exchange_tokens(
      client_id: @client.identifier,
      client_secret: @client.secret + '-wrong',
      code: @authorization.code,
      redirect_uri: @authorization.redirect_uri
    )
    response_should_be_401_unauthorized
  end

  it 'responds 400 bad request without authorization code' do
    exchange_tokens(
      client_id: @client.identifier,
      client_secret: @client.secret,
      redirect_uri: @authorization.redirect_uri
    )
    response_should_be_400_bad_request
  end

  it 'responds 400 bad request with not existing authorization code' do
    exchange_tokens(
      client_id: @client.identifier,
      client_secret: @client.secret,
      code: 'not-existing-authorization-code',
      redirect_uri: @authorization.redirect_uri
    )
    response_should_be_400_bad_request
  end

  it 'responds 400 bad request with expired authorization code' do
    Timecop.travel(@authorization.expires_at + 1.second) do
      exchange_tokens(
        client_id: @client.identifier,
        client_secret: @client.secret,
        code: @authorization.code,
        redirect_uri: @authorization.redirect_uri
      )
      response_should_be_400_bad_request
    end
  end

  it 'responds 400 bad request without redirect_uri' do
    exchange_tokens(
      client_id: @client.identifier,
      client_secret: @client.secret,
      code: @authorization.code
    )
    response_should_be_400_bad_request
  end

  it 'responds 400 bad request with wrong redirect_uri' do
    exchange_tokens(
      client_id: @client.identifier,
      client_secret: @client.secret,
      code: @authorization.code,
      redirect_uri: @authorization.redirect_uri + '-wrong'
    )
    response_should_be_400_bad_request
  end
end
