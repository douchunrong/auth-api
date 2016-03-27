require 'rails_helper.rb'

describe 'user_account_context' do
  include_context 'user_account'
  include_context 'user'

  describe 'user_account_exists' do
    it 'is okay to call twice with same email' do
      user_account_exists parti: { identifier: 'same-identifier' }
      user_account_exists parti: { identifier: 'same-identifier' }
    end
  end

  describe 'user_accounts_not_exist' do
    it 'removes existing user_account' do
      user_account = user_account_exists

      user_accounts_not_exist parti: { identifier: user_account.parti.identifier }

      user_accounts_should_not_exist id: user_account.id
    end

    it 'removes two existing user_accounts' do
      user_accounts  = user_accounts_exist count: 2
      user_identifiers = user_accounts.map { |account| account.parti.identifier }

      user_accounts_not_exist parti: { identifier: user_identifiers }

      user_accounts_should_not_exist id: user_accounts.map(&:id)
    end
  end
end
