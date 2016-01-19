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
    scenario 'Authorization request is approved' do
      client, * = registered_clients_exist
      user, * = users_exist
      user_is_in_login_status_as user

      req_params = {
        client_id: client.identifier,
        nonce: "nonce-#{client.identifier}",
        redirect_uri: client.redirect_uri,
        response_type: 'code',
        scope: 'openid',
        state: "state-#{client.identifier}"
      }

      request_authorization req_params

      user_should_see_approve_form_of req_params
    end
  end

  scenario 'connect/fakes#create' do
    client, * = registered_clients_exist

    req_params = {
      client_id: client.identifier,
      nonce: 'ce4f9ed92a62d6e72cc13935c58a9bfc',
      redirect_uri: client.redirect_uris.first,
      response_type: 'code',
      scope: 'openid profile email address',
      state: 'ce4f9ed92a62d6e72cc13935c58a9bfc'
    }

    auth_req_url = new_authorization_url req_params
    visit auth_req_url

    click_button 'Create Fake Account'
    do_not_follow_redirect do
      click_button 'approve'
    end

    expect(page.status_code).to eq(302)
    expect(page.response_headers['Location'])
      .to be_valid_oauth_auth_resp_url_of(auth_req_url)

    code = fetch_auth_code page.response_headers['Location']
    expect(code).to be_valid_oauth_code_of(req_params)
  end

  def fetch_auth_code(uri_str)
    UriHelper.fetch_params_from_uri(page.response_headers['Location'])['code']
  end
end
