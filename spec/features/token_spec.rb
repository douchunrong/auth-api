feature 'Authorization' do
  include_context 'authorization'
  include_context 'token'
  include_context 'user'
  include_context 'user_info'

  scenario 'Client receives token using authorization code' do
    authorization = authorization_is_granted

    request_token authorization

    token_should_be_received
  end

  scenario 'Client receives userinfo using access_token' do
    user = user_exists email: 'one@email.com'
    authorization = authorization_is_granted_for user,
      scope: 'openid profile email'
    token = token_is_granted_for authorization

    request_user_info token

    userinfo_should_be_received(
      email: 'one@email.com'
    )
  end
end
