require 'rails_helper.rb'

describe 'clean database for test' do
  include_context 'feature'
  include_context 'database'

  it 'clean database' do
    client = client_exists
    token = token_is_granted_by_client_credentials client: client

    clean_database_for_test token: token.token

    response_should_be_204_no_content
    database_should_be_clean
  end
end
