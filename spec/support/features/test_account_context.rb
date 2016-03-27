shared_context 'test_account' do
  def test_accounts_exist(attrs_set = [{}], **options)
    if options[:count]
      attrs_set = attrs_set.cycle.take(options[:count])
    end
    attrs_options = options.except(:count)
    attrs_set.map do |attrs|
      test_account_exists attrs_options.merge(attrs)
    end
  end

  def test_account_exists(attrs = {})
    FactoryGirl.create :test_account_parti, attrs
  end

  def create_test_account(client:, token: nil)
    if token
      header 'Authorization', "Bearer #{token}"
    end
    post "/v1/clients/#{client.identifier}/test-accounts"
  end

  def delete_all_test_accounts(client_id:, token: nil)
    if token
      header 'Authorization', "Bearer #{token}"
    end
    delete "/v1/clients/#{client_id}/test-accounts"
  end

  def response_should_render_test_account
    last_account = Account.createds.last
    expect(last_response.body).to be_json_eql(<<-JSON)
    {
      "identifier": "#{last_account.identifier}",
      "type": "test-account",
      "parti": {
        "identifier": "#{last_account.parti.identifier}"
      }
    }
    JSON
  end

  def test_account_should_be_created(client:)
    last_account = Account.createds.last
    expect(last_account).to be_instance_of(TestAccount)
    expect(last_account.client).to eq(client)
  end

  def all_test_accounts_should_be_deleted(client:)
    expect(client.test_accounts).to be_empty
  end

  def verify_test_account(test_account)
    connect_sum = [test_account.parti, test_account.internal].map { |c| c.nil? ? 0 : 1 }.inject(0, :+)
    expect(connect_sum).to eq(1)
    expect(test_account.client).to be_present
  end
end
