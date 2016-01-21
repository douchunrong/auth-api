shared_context 'client' do
  def registered_clients_exist
    FactoryGirl.create(:client)
  end

  def client_is_in_parti_login_status_as(user)
    login_as(user, :scope => :user)
    authenticate Connect::Parti.authenticate
    logged_in!
    set_rack_session session
  end
end
