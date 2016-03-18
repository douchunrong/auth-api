shared_context 'user_test' do
  def create_users_for_for_test(token: nil, attrs_set: [{}])
    if token
      header 'Authorization', "Bearer #{token}"
    end
    post "/v1/test/users", { attrs_set: attrs_set }, { 'Content-Type' => 'application/json' }
  end

  def delete_user_for_test(token: nil, user_id:)
    if token
      header 'Authorization', "Bearer #{token}"
    end
    delete "/v1/test/users/#{user_id}"
  end

  def list_users_for_test(token: nil, **attrs)
    if token
      header 'Authorization', "Bearer #{token}"
    end
    get '/v1/test/users', attrs
  end

  def verify_user_passowrd_for_test(user_id:, token: nil, **params)
    if token
      header 'Authorization', "Bearer #{token}"
    end
    post "/v1/test/users/#{user_id}/verify-password", params
  end
end
