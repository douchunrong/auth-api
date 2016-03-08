require 'rails_helper.rb'

describe 'Sign out' do
  include_context 'feature'

  it 'invalidates token' do
    user = user_exists email: 'user@email.com'
    token = valid_user_token_exists user: user

    sign_out token: token

    user_token_in_response_is_empty
    user_token_should_not_be_valid(
      token: token,
      email: 'user@email.com'
    )
  end

  it 'does not invalidates token in another session' do
    user = user_exists email: 'user@email.com'
    another_token = valid_user_token_exists user: user
    token = valid_user_token_exists user: user

    sign_out token: token
    user_token_should_be_valid(
      token: another_token,
      email: 'user@email.com'
    )
  end
end
