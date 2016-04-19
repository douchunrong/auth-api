shared_context 'client_test' do
  def create_client_for_test(token: nil, **attrs)
    if token
        header 'Authorization', "Bearer #{token}"
    end

    post '/test/clients', attrs.to_json,
      'CONTENT_TYPE' => 'application/json'
  end

  def created_client_should_be_rendered
    last_client = Client.createds.last
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
