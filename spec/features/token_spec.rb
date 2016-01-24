feature 'Authorization' do
  include_context 'authorization'
  include_context 'token'

  scenario 'Client receives token using authorization code' do
    authorization = authorization_is_granted

    request_token authorization

    token_should_be_received
  end
end

