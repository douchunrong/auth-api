shared_context 'feature' do
  include_context 'authorization'
  include_context 'client'
  include_context 'rack_test'
  include_context 'token'
  include_context 'test_account'
  include_context 'user'
  include_context 'user_account'
  include_context 'user_account_test'

  before :each do
    ApplicationRecordTest.clear_createds
  end
end
