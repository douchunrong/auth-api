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

    it 'creates account with client' do
      account = create_test_account client: @client
      expect(account.client).to eql @client
    end
  end
end
