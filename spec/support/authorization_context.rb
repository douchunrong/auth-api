shared_context 'authorization' do

  def registered_clients_exist
    FactoryGirl.create(:client)
  end

  def user_is_not_in_login_status

  end

  def request_authorization(attrs = {})
    default_attrs = { response_type: 'code' }
    params = default_attrs.merge attrs.slice(
      :client_id, :redirect_uri, :response_type
    )
    get new_authorization_path, params
  end

  def user_should_see_login_form
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.url).to eq 'http://example.org/'
  end

end
