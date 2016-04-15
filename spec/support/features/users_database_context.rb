shared_context 'users_database' do
  include_context 'token'
  include_context 'users_api'

  def clean_users_database_for_test
    token = token_is_granted_by_client_credentials(
      client: auth_api_test_client
    )
    conn = users_api_conn
    response = conn.post do |req|
      req.url '/v1/test/database/clean'
      req.headers['Authorization'] = "Bearer #{token.token}"
    end
    expect(response.status).to eq(204)
  end
end
