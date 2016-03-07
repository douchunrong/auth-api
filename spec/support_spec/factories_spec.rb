require 'rails_helper.rb'

describe 'account factory' do
  include_context 'account'

  it 'builds valid account' do
    account = FactoryGirl.build(:account)
    verify_account account
  end

  it 'creates valid account' do
    account = FactoryGirl.create(:account)
    verify_account account
  end
end
