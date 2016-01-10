shared_context 'client' do

  def registered_clients_exist
    FactoryGirl.create(:client)
  end

end
