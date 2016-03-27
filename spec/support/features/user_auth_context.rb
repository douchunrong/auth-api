shared_context 'user_auth' do
  def valid_user_token_exists(user:)
    sign_in_as user
    user_token_in_response(last_response)
  end

  def user_token_should_be_valid(email:, token:)
    expect(token[:uid]).to eq(email)
    user = User.find_by_email(email)
    expect(user.valid_token? token[:access_token], token[:client]).to be true
  end

  def user_token_should_not_be_valid(email:, token:)
    expect(token[:uid]).to eq(email)
    user = User.find_by_email(email)
    expect(user.valid_token? token[:access_token], token[:client]).to be false
  end

  def user_token_in_response_should_be_valid(email:)
    token, client, uid = user_token_in_response(last_response).values_at :access_token, :client, :uid
    expect(uid).to eq(email)
    user = User.find_by_email(email)
    user.valid_token? token, client
  end

  def user_token_in_response(response)
    response.headers.slice('access-token', 'client', 'uid')
      .transform_keys { |key| key.parameterize.underscore.to_sym }
  end

  def user_token_in_response_is_empty
    expect(user_token_in_response(last_response)).to be_empty
  end
end
