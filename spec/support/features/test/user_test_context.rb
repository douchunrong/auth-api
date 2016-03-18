shared_context 'user_test' do
  def verify_user_passowrd_for_test(user_id:, token: nil, **params)
    if token
      header 'Authorization', "Bearer #{token}"
    end
    post "/v1/test/users/#{user_id}/verify-password", params
  end
end
