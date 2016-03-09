require 'rails_helper.rb'

describe 'token_is_granted' do
  include_context 'feature'

  it 'creates access_token' do
    account = user_account_exists
    client = auth_api_test_client
    token = token_is_granted(
      account: account,
      client: client,
      scope: Scope::CREATE_CLIENT
    )
    access_token = AccessToken.valid.find_by token: token
    expect(access_token).not_to be_nil
    expect(access_token.scopes.map(&:name)).to contain_exactly(Scope::CREATE_CLIENT)
  end
end
