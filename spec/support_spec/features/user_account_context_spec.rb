require 'rails_helper.rb'

describe 'user_account_context' do
  include_context 'user_account'
  include_context 'user'

  describe 'user_account_exists' do
    it 'is okay to call twice with same email' do
      user_account_exists parti: { email: 'same@email.com' }
      user_account_exists parti: { email: 'same@email.com' }
    end
  end

  describe 'user_accounts_not_exist' do
    it 'removes existing user_account' do
      user_account = user_account_exists

      user_accounts_not_exist parti: { email: user_account.parti.user.email }

      user_accounts_should_not_exist id: user_account.id
      users_should_not_exist email: user_account.parti.user.email
    end

    it 'removes two existing user_accounts' do
      user_accounts  = user_accounts_exist count: 2
      user_emails = user_accounts.map { |account| account.parti.user.email }

      user_accounts_not_exist parti: { email: user_emails }

      user_accounts_should_not_exist id: user_accounts.map(&:id)
      users_should_not_exist email: user_emails
    end
  end
end
