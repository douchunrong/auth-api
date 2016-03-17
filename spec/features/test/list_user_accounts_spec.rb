require 'rails_helper.rb'

describe 'list user accounts for test' do
  include_context 'feature'

  before :each do
    @client = client_exists
    @token = token_is_granted_by_client_credentials client: @client
  end

  it 'lists user_account by identifier' do
    wally_account = user_account_exists parti: { email: 'wally@email.com' }

    list_user_accounts_for_test(
      attrs: {
        identifier: wally_account.identifier
      }.to_json,
      token: @token
    )

    wally_account.parti.user.password = nil
    response_should_render_user_accounts [ wally_account ]
  end

  it 'lists user_account by parti email' do
    wally_account = user_account_exists parti: { email: 'wally@email.com' }

    list_user_accounts_for_test(
      attrs: {
        parti: { email: 'wally@email.com' }
      }.to_json,
      token: @token
    )

    wally_account.parti.user.password = nil
    response_should_render_user_accounts [ wally_account ]
  end

  it 'lists empty with parti email not exists' do
    user_accounts_not_exist parti: { email: 'wally@email.com' }

    list_user_accounts_for_test(
      attrs: {
        parti: { email: 'wally@email.com' }
      }.to_json,
      token: @token
    )

    response_should_render_user_accounts []
  end

  it 'list empty with invalid parti params' do
    list_user_accounts_for_test(
      attrs: {
        parti: 'invalid-parti-attrs'
      }.to_json,
      token: @token
    )
    response_should_render_user_accounts []
  end

  it 'responds 400 bad request with invalid json' do
    list_user_accounts_for_test(
      attrs: '[ { invalid-json } ]',
      token: @token
    )

    response_should_be_400_bad_request
  end

  it 'responds 401 unauthorized without token' do
    list_user_accounts_for_test(
      attrs: {
        parti: { email: 'wally@email.com' }
      }.to_json
    )

    response_should_be_401_unauthorized
  end
end
