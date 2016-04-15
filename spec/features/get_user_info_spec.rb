require 'rails_helper'

describe 'User info' do
  include_context 'feature'

  it 'responds user info of parti user' do
    user = parti_user_exists
    account = user_account_exists parti: { identifier: user[:identifier] }
    client = auth_api_test_client
    token = access_token_is_granted(
      account: account,
      client: client
    )

    request_user_info token: token

    user_info_should_be_rendered user: user
  end
end
