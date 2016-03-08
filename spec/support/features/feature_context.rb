shared_context 'feature' do
  include_context 'account'
  include_context 'auth'
  include_context 'client'
  include_context 'rack_test'
  include_context 'sign_up'
  include_context 'user'

  before :each do
    ApplicationRecordTest.clear_last_created
  end
end
