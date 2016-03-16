require 'rails_helper.rb'

describe Test::Factories::User do
  include Test::Factories::User

  describe 'user_exists' do
    it 'creates user record' do
      expect { user_exists }.to change{ User.count }.by(1)
    end

    it 'creates confirmed user by default' do
      Timecop.freeze do
        user = user_exists
        expect(user.confirmation_sent_at).to eq(Time.now)
        expect(user.confirmed_at).to eq(Time.now)
        expect(user.tokens).to be_blank
        expect(user.created_at).to eq(Time.now)
        expect(user.updated_at).to eq(Time.now)
      end
    end

    it 'creates unconfirmed' do
      Timecop.freeze do
        user = user_exists confirm: false
        expect(user.confirmation_token).not_to be_blank
        expect(user.confirmation_sent_at).to eq(Time.now)
        expect(user.confirmed_at).to be_blank
        expect(user.tokens).to be_blank
        expect(user.created_at).to eq(Time.now)
        expect(user.updated_at).to eq(Time.now)
      end
    end

    it 'is okay to call twice' do
      user_exists()
      user_exists()
    end

    it 'creates with email' do
      user = user_exists email: 'any@email.com'
      expect(user.email).to eq('any@email.com')
    end
  end

  describe 'users_exist' do
    it 'creates one user' do
      users = users_exist
      expect(users.size).to eq(1)
      expect(users.first).to be_valid
    end

    it 'creates two users' do
      users = users_exist [ {}, {} ]
      expect(users.size).to eq(2)
      users.each { |user| expect(user).to be_valid }
    end

    it 'accepts :count option' do
      users = users_exist count: 2
      expect(users.size).to eq(2)
      users.each { |user| expect(user).to be_valid }
    end
  end
end
