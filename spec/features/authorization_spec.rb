require 'rails_helper'

feature 'Authorization' do
  include_context 'authorization'
  include_context 'client'
  include_context 'user'

  context 'User is not in login status' do

    scenario 'Authorization request prompts login form' do
      client, * = registered_clients_exist
      user_is_not_in_login_status
      request_authorization(
        client_id: client.identifier,
        redirect_uri: client.redirect_uri
      )
      user_should_see_login_form
    end

  end

  context 'User is in login status' do

    scenario 'Authorization request prompts login form' do
      client, * = registered_clients_exist
      user, * = users_exist
      user_is_in_login_status_as user

      request_authorization(
        client_id: client.identifier,
        redirect_uri: client.redirect_uri
      )

      user_should_see_login_form
    end

  end

end
