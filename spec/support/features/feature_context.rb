shared_context 'feature' do
  include_context 'account'
  include_context 'auth'
  include_context 'client'
  include_context 'rack_test'
  include_context 'sign_in'
  include_context 'sign_out'
  include_context 'sign_up'
  include_context 'user'
  include_context 'user_auth'

  before :each do
    ApplicationRecordTest.clear_last_created
  end
end
