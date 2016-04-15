require 'rails_helper'

describe 'parti_user_context' do
  include_context 'parti_user'
  include_context 'users_database'

  before :each do
    clean_users_database_for_test
  end

  describe 'parti_user_exists' do
    it 'creates parti_user without attributes' do
      user = parti_user_exists
      expect(user[:identifier]).to be_present
      expect(user[:email]).to be_present
      parti_user_should_exists user
    end

    it 'creates parti_user with attributes' do
      user = parti_user_exists(
        email: 'user@email.com'
      )
      expect(user[:identifier]).to be_present
      expect(user[:email]).to eq('user@email.com')
      parti_user_should_exists user
    end
  end
end
