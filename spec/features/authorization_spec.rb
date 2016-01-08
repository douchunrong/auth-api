require 'rails_helper'

feature 'Authorization' do
  include_context 'authorization'

  context 'User is not in login status' do

    scenario 'Authorization request prompts login form' do
      user_is_not_in_login_status
      request_authorization
      user_should_see_login_form
    end

  end

end
