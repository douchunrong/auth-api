shared_context 'user_info' do
  def request_user_info(token)
    header  'Authorization', "Bearer #{token[:access_token]}"
    get user_info_path
  end

  def userinfo_should_be_received(attrs)
    expect(last_response).to be_ok
    resp = JSON.parse(last_response.body)
    expect(resp).to include(attrs)
  end
end
