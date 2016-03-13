require 'rails_helper.rb'

describe 'user_auth_token_exists' do
  include_context 'user'

  it 'returns user_auth_token' do
    auth_token = user_auth_token_exists
    expect(auth_token[:access_token]).not_to be_blank
    expect(auth_token[:client]).not_to be_blank
    expect(auth_token[:uid]).not_to be_blank
  end
end
