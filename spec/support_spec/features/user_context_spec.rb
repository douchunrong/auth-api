require 'rails_helper.rb'

describe 'user_token_exists' do
  include_context 'user'

  it 'returns user_token' do
    user_token = user_token_exists(
      identifier: 'parti-identifer'
    )
    expect(user_token[:access_token]).not_to be_blank
    expect(user_token[:client]).not_to be_blank
    expect(user_token[:uid]).not_to be_blank

    conn = Faraday.new url: users_api_url
    response = conn.get do |req|
      req.url '/v1/users/validate_token'
      req.headers['access-token'] = user_token[:access_token]
      req.headers['client'] = user_token[:client]
      req.headers['uid'] = user_token[:uid]
    end
    expect(response.status).to eq(200)
  end
end
