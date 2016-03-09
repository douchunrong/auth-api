require 'rails_helper.rb'

describe TestAccountHelper do
  include TestAccountHelper
  include_context 'client'

  before :all do
    @client = client_exists
  end

  describe '#create_test_account' do
    it 'creates test_account record' do
      expect {
        create_test_account client: @client
      }.to change { TestAccount.count }.by(1)
    end

    it 'creates connect_parti record' do
      expect {
        create_test_account client: @client
      }.to change { ConnectParti.count }.by(1)
    end

    it 'creates user record' do
      expect {
        create_test_account client: @client
      }.to change { User.count }.by(1)
    end

    it 'creates connect_parti record' do
      expect {
        create_test_account client: @client
      }.to change { ConnectParti.count }.by(1)
    end

    it 'creates account with client' do
      account = create_test_account client: @client
      expect(account.client).not_to be_nil
    end

    it 'creates confirmed user' do
      account = create_test_account client: @client
      expect(account.parti.user).to be_confirmed
    end

    it 'overrides password' do
      account = create_test_account(
        client: @client,
        password: 'Passw0rd!'
      )
      expect(account.parti.user.valid_password? 'Passw0rd!').to be true
    end
  end
end
