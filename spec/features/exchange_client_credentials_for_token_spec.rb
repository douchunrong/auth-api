require 'rails_helper.rb'

describe 'Exchanges client credentials for token' do
  include_context 'feature'

  before :all do
    @client = client_exists
  end

  it 'grants token' do
    exchange_client_credentials_for_token(
      client_id: @client.identifier,
      client_secret: @client.secret,
    )

    response = response_should_render_access_token
    access_tokens_should_be_granted(
      access_token: response[:access_token],
      client: @client
    )
  end

  it 'responds 401 unauthorized with wrong client id' do
    exchange_client_credentials_for_token(
      client_id: @client.identifier + '-wrong',
      client_secret: @client.secret,
    )
    response_should_be_401_unauthorized
  end

  it 'responds 401 unauthorized with wrong client secret' do
    exchange_client_credentials_for_token(
      client_id: @client.identifier,
      client_secret: @client.secret + '-wrong',
    )
    response_should_be_401_unauthorized
  end

  it 'responds 400 bad request without client credentials' do
    exchange_client_credentials_for_token_without_credential
    response_should_be_400_bad_request
  end
end
