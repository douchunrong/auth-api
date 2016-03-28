require 'rails_helper.rb'

describe 'list user accounts for test' do
  include_context 'feature'

  before :each do
    @client = client_exists
    @token = token_is_granted_by_client_credentials client: @client
  end

  it 'lists user_account by identifier' do
    wally_account = user_account_exists parti: { identifier: 'wally-identifier' }

    list_user_accounts_for_test(
      where: {
        identifier: wally_account.identifier
      }.to_json,
      token: @token.token
    )

    response_should_render_user_accounts [ wally_account ]
  end

  it 'lists all user_accounts with empty where' do
    list_user_accounts_for_test(
      where: {}.to_json,
      token: @token.token
    )
    response_should_render_user_accounts UserAccount.all
  end

  it 'lists empty with parti identifier not exists' do
    user_accounts_not_exist parti: { identifier: 'wally-identifier' }

    list_user_accounts_for_test(
      where: {
        parti: { identifer: 'wally-identifier' }
      }.to_json,
      token: @token.token
    )

    response_should_render_user_accounts []
  end

  it 'list all user_accounts with invalid parti params' do
    list_user_accounts_for_test(
      where: {
        parti: 'invalid-parti-attrs'
      }.to_json,
      token: @token.token
    )
    response_should_render_user_accounts UserAccount.all
  end

  it 'list all user_accounts without where parameter' do
    list_user_accounts_for_test(
      token: @token.token
    )
    response_should_render_user_accounts UserAccount.all
  end

  it 'responds 400 bad request with invalid json' do
    list_user_accounts_for_test(
      where: '[ { invalid-json } ]',
      token: @token.token
    )

    response_should_be_400_bad_request
  end

  it 'responds 401 unauthorized without token' do
    list_user_accounts_for_test(
      where: {
        parti: { email: 'wally@email.com' }
      }.to_json
    )

    response_should_be_401_unauthorized
  end
end
