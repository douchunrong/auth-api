require 'rails_helper'

describe 'create client for test' do
  include_context 'feature'

  it 'create client without params' do
    client = client_exists
    token = token_is_granted_by_client_credentials client: client
    ApplicationRecordTest.clear_createds

    create_client_for_test token: token.token

    created_client_should_be_rendered
  end
end
