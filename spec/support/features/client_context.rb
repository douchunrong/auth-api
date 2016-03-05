shared_context 'client' do
  def create_client(params)
    client_params = params.slice(:redirect_uris, :name)
    header 'Authorization', "Bearer #{params[:token]}"
    post '/v1/clients', client: client_params
  end

  def client_should_be_created(params)
    last_client = Client.last_created
    expect(last_client).not_to be_nil
    expect(last_client.account).to eql(params[:account])
    expect(params[:redirect_uris]).to match_array(last_client.redirect_uris)
  end

  def auth_api_test_client()
    account = Account.joins(:internal).find_by!(
      connect_internals: { name: ConnectInternal::PARTI_AUTH_INTERNAL_NAME }
    )
    account.clients.find_by! name: Client::PARTI_AUTH_API_TEST_CLIENT_NAME
  end

  def response_should_render_created_client
    last_client = Client.last_created
    expect(last_response.status).to eq(201)
    expect(last_response.body).to be_json_eql(<<-JSON)
    {
      "client_id": "#{last_client.identifier}",
      "client_secret": "#{last_client.secret}",
      "name": "#{last_client.name}",
      "redirect_uris": #{last_client.redirect_uris.as_json}
    }
    JSON
  end
end
