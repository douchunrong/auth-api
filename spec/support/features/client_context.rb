def create_client(params)
  client_params = params.slice(:redirect_uris)
  header 'Authorization', "Bearer #{params[:token]}"
  post '/v1/clients', client: client_params
end

def client_should_be_created(params)
  last_client = Client.last_created
  expect(last_client).not_to be_nil
  expect(last_client.account.parti.user).to eql(params[:user])
  expect(params[:redirect_uris]).to match_array(last_client.redirect_uris)
end
