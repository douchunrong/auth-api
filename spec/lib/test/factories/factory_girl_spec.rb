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
      user = FactoryGirl.create :user, confirm: false

      user.reload
      expect(user).not_to be_confirmed
    end
  end

  describe 'user_account' do
    it 'creates parti user account by default' do
      account = FactoryGirl.create :user_account

      account.reload
      expect(account.parti).to be_blank
    end
  end

  describe 'user_account_parti' do
    it 'creates parti user account by default' do
      account = FactoryGirl.create :user_account_parti

      account.reload
      expect(account.parti.user).to be_valid
      expect(account.parti.user).to be_confirmed
    end

    it 'creates parti user with attributes' do
      account = FactoryGirl.create :user_account_parti,
        parti: {
          email: 'parti@email.com',
          password: 'parti-password'
        }

      account.reload
      expect(account.parti.user).to be_valid
      expect(account.parti.user).to be_confirmed
      expect(account.parti.user.email).to eq('parti@email.com')
      expect(account.parti.user.valid_password? 'parti-password').to be true
    end

    it 'creates parti user unconfirmed' do
      account = FactoryGirl.create :user_account_parti,
        parti: { confirm: false }

      account.reload
      expect(account.parti.user).not_to be_confirmed
    end
  end
end
