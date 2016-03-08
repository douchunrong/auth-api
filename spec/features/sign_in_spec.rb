require 'rails_helper.rb'

describe 'Sign in' do
  include_context 'feature'

  it 'responds with token with valid credential' do
    user_exists(
      email: 'one@email.com',
      password: 'Passw0rd!'
    )

    sign_in(
      email: 'one@email.com',
      password: 'Passw0rd!'
    )

    user_token_in_response_should_be_valid email: 'one@email.com'
  end
end
