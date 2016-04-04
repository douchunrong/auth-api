require 'rails_helper'
require 'factories'

describe 'factories' do
  describe 'test_account' do
    it 'creates without connect' do
      account = FactoryGirl.create :test_account
      expect(account.parti).to be_blank
      expect(account.internal).to be_blank
    end
  end

  describe 'test_account_parti' do
    it 'builds parti test account' do
      account = FactoryGirl.build :test_account_parti
      expect(account).to be_new_record
      expect(account.parti).to be_new_record
    end

    it 'build parti test account with parti attributes' do
      account = FactoryGirl.build :test_account_parti, parti: { identifier: 'random-identifier' }
      expect(account.parti.identifier).to eq('random-identifier')
    end

    it 'creates parti test account' do
      account = FactoryGirl.create :test_account_parti
      expect(account).not_to be_new_record
      expect(account.parti).not_to be_new_record
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
