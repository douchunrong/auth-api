shared_context 'test_account' do
  def create_test_account(client:, token: nil)
    if token
      header 'Authorization', "Bearer #{token}"
    end
    post "/v1/clients/#{client.identifier}/test-accounts"
  end

  def response_should_render_test_account
    last_account = Account.last_created
    expect(last_response.body).to be_json_eql(<<-JSON)
    {
      "id": "#{last_account.identifier}",
      "type": "test-account",
      "parti": {
        "email": "#{last_account.parti.user.email}",
        "password": "#{last_account.parti.user.password}",
        "created_at": "#{last_account.parti.user.created_at}"
      }
    }
    JSON
  end

  def test_account_should_be_created(client:)
    last_account = Account.last_created
    expect(last_account).to be_instance_of(TestAccount)
    expect(last_account.client).to eq(client)
  end
end
