require 'rails_helper.rb'

describe 'sign_in_as' do
  include_context 'sign_in'
  include_context 'user'
  include_context 'user_auth'

  it 'signs in with user' do
    user = user_exists

    sign_in_as user

    user_token_in_response_should_be_valid email: user.email
  end
end

