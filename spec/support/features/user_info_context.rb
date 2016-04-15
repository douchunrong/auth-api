shared_context 'user_info' do
  include_context 'rack_test'

  def request_user_info(token: nil)
    if token
      header 'Authorization', "Bearer #{token.token}"
    end
    get '/v1/user-info'
  end

  def user_info_should_be_rendered(user:)
    response_should_be_200_ok_json
    expect(last_response.body).to be_json_eql(<<-JSON)
      {
        "email": "#{user[:email]}"
      }
    JSON
  end
end
