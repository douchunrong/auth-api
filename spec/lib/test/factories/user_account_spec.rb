require 'rails_helper.rb'

describe Test::Factories::UserAccount do
  include Test::Factories::UserAccount

  describe 'user_account_exists' do
    it 'creates records' do
      account_count = UserAccount.count
      parti_count = ConnectParti.count

      user_account_exists

      expect(UserAccount.count).to eq(account_count + 1)
      expect(ConnectParti.count).to eq(parti_count + 1)
    end

    it 'is okay to call twice' do
      user_account_exists()
      user_account_exists()
    end

    it 'creates with parti identifier' do
      account = user_account_exists(
        parti: { identifier: 'parti-identifier' }
      )
      expect(account.parti.identifier).to eq('parti-identifier')
    end

    xit 'raises error creating with same identifier' do
      user_account_exists parti: { identifier: 'same-identifier' }
      account_count = UserAccount.count
      expect {
        user_account_exists parti: { identifier: 'same-identifier' }
      }.to raise_error(ActiveRecord::RecordNotUnique)
      expect(UserAccount.count).to eq(account_count)
    end
  end

  describe 'user_accounts_exist' do
    it 'creates one user_account' do
      accounts = user_accounts_exist
      expect(accounts.size).to eq(1)
      expect(accounts.first).to be_valid
    end

    it 'creates two user_accounts' do
      accounts = user_accounts_exist [ {}, {} ]
      expect(accounts.size).to eq(2)
      accounts.each { |account| expect(account).to be_valid }
    end

    it 'accepts :count option' do
      accounts = user_accounts_exist count: 2
      expect(accounts.size).to eq(2)
      accounts.each { |account| expect(account).to be_valid }
    end
  end
end
