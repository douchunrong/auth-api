shared_context 'feature' do
  include_context 'auth_code_test'
  include_context 'authorization'
  include_context 'client'
  include_context 'client_test'
  include_context 'parti_user'
  include_context 'rack_test'
  include_context 'token'
  include_context 'test_account'
  include_context 'user'
  include_context 'user_account'
  include_context 'user_account_test'
  include_context 'user_info'

  before :each do
    ApplicationRecordTest.clear_createds
  end
end
