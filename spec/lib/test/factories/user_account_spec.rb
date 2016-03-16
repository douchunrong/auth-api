require 'rails_helper.rb'

describe Test::Factories::UserAccount do
  include Test::Factories::UserAccount

  describe 'user_account_exists' do
    it 'creates records' do
      user_count = User.count
      account_count = UserAccount.count
      parti_count = ConnectParti.count

      user_account_exists

      expect(User.count).to eq(user_count + 1)
      expect(UserAccount.count).to eq(account_count + 1)
      expect(ConnectParti.count).to eq(parti_count + 1)
    end

    it 'is okay to call twice' do
      user_account_exists()
      user_account_exists()
    end

    it 'raises error calling twice with same email' do
      user_account_exists parti: { email: 'same@email.com' }
      expect {
        user_account_exists parti: { email: 'same@email.com' }
      }.to raise_error(ActiveRecord::StatementInvalid)
    end

    it 'creates with parti email' do
      account = user_account_exists(
        parti: {
          email: 'parti@email.com',
          password: 'PartiPass'
        }
      )
      expect(account.parti.user.email).to eq('parti@email.com')
      expect(account.parti.user).to be_confirmed
      expect(account.parti.user.valid_password? 'PartiPass').to be true
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
