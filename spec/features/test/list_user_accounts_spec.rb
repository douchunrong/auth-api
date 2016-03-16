require 'rails_helper.rb'

describe 'list user accounts for test' do
  include_context 'feature'

  it 'lists user_account by id' do
    client = client_exists
    token = token_is_granted_by_client_credentials client: client
    wally_account = user_account_exists parti: { email: 'wally@email.com' }

    list_user_accounts_for_test(
      id: wally_account.id,
      token: token
    )

    wally_account.parti.user.password = nil
    response_should_render_user_accounts [ wally_account ]
  end

  it 'lists user_account by parti email' do
    client = client_exists
    token = token_is_granted_by_client_credentials client: client
    wally_account = user_account_exists parti: { email: 'wally@email.com' }

    list_user_accounts_for_test(
      parti: {
        email: 'wally@email.com'
      },
      token: token
    )

    wally_account.parti.user.password = nil
    response_should_render_user_accounts [ wally_account ]
  end

  it 'lists empty with parti email not exists' do
    client = client_exists
    token = token_is_granted_by_client_credentials client: client
    user_accounts_not_exist parti: { email: 'wally@email.com' }

    list_user_accounts_for_test(
      parti: {
        email: 'wally@email.com'
      },
      token: token
    )

    response_should_render_user_accounts []
  end

  it 'responds 401 unauthorized without token' do
    user_accounts_not_exist parti: { email: 'wally@email.com' }

    list_user_accounts_for_test parti: { email: 'wally@email.com' }

    response_should_be_401_unauthorized
  end
end
