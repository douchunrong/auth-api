shared_context 'user' do

  def users_exist

  end

  def user_is_not_in_login_status

  end

  def user_is_in_login_status_as(user)
  end

  def user_should_see_login_form
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.url).to eq 'http://example.org/'
  end

end
