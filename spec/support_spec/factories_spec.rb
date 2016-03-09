require 'rails_helper.rb'

describe 'user_account factory' do
  include_context 'user_account'

  it 'builds valid user_account' do
    account = FactoryGirl.build(:user_account)
    verify_user_account account
  end

  it 'creates valid account' do
    account = FactoryGirl.create(:user_account)
    verify_user_account account
  end
end
