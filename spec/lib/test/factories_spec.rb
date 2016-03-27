require 'rails_helper'
require 'test/factories'

describe 'factories' do
  describe 'user' do
    it 'creates confirmed user by default' do
      user = FactoryGirl.create :user

      user.reload
      expect(user).to be_confirmed
    end

    it 'creates unconfirmed' do
      user = FactoryGirl.create :user, confirm: false

      user.reload
      expect(user).not_to be_confirmed
    end
  end

  describe 'user_account' do
    it 'does not create parti user account' do
      account = FactoryGirl.create :user_account

      account.reload
      expect(account.parti).to be_blank
    end
  end

  describe 'user_account_parti' do
    it 'builds parti user account' do
      account = FactoryGirl.build :user_account_parti
      expect(account).to be_new_record
      expect(account.parti).to be_new_record
    end

    it 'build parti user account with parti attributes' do
      account = FactoryGirl.build :user_account_parti, parti: { identifier: 'random-identifier' }
      expect(account.parti.identifier).to eq('random-identifier')
    end

    it 'creates one parti user account' do
      account_count = UserAccount.count
      parti_count = ConnectParti.count

      FactoryGirl.create :user_account_parti

      expect(UserAccount.count).to eq(account_count + 1)
      expect(ConnectParti.count).to eq(parti_count + 1)
    end
  end
end
