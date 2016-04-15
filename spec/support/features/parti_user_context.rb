shared_context 'parti_user' do
  include_context 'client'
  include_context 'token'
  include_context 'users_api'

  def parti_user_exists(attrs = {})
    token = token_is_granted_by_client_credentials(
      client: auth_api_test_client
    )
    conn = users_api_conn
    response = conn.post do |req|
      req.url '/v1/test/users'
      req.headers['Authorization'] = "Bearer #{token.token}"
      req.body = { users: [ attrs ] }
    end
    expect(response.status).to eq(200)
    user = JSON.parse(response.body).first || {}
    user.with_indifferent_access
  end

  def parti_user_should_exists(attrs)
    token = token_is_granted_by_client_credentials(
      client: auth_api_test_client
    )
    conn = users_api_conn
    response = conn.get do |req|
      req.url '/v1/test/users'
      req.headers['Authorization'] = "Bearer #{token.token}"
      req.params = attrs
    end
    expect(response.status).to eq(200)
    users = JSON.parse(response.body)
    expected_user = users.select do |user|
      user.with_indifferent_access.slice(*attrs.keys) == attrs.except(:password)
    end
    expect(expected_user).to be_present
  end
end

