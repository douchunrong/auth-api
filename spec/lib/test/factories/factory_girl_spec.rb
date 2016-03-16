require 'rails_helper.rb'
require 'test/factories/factory_girl'

describe 'factories' do
  describe 'user' do
    it 'creates confirmed user by default' do
      user = FactoryGirl.create :user

      user.reload
      expect(user).to be_confirmed
    end

    it 'creates unconfirmed' do
      user = FactoryGirl.create :user, confirmed: false

      user.reload
      expect(user).not_to be_confirmed
    end
  end

  describe 'user_account' do
    it 'creates parti user account by default' do
      account = FactoryGirl.create :user_account

      account.reload
      expect(account.parti.user).to be_valid
      expect(account.parti.user).to be_confirmed
    end
  end
end
