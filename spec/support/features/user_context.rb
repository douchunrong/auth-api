require 'rails_helper'

shared_context 'user' do
  include PartiUrlHelper

  def user_token_exists(identifier:)
    user_token = {
      access_token: 'access_token',
      client: 'client',
      uid: 'uid',
    }
    stub_request(:get, users_api_url('/v1/users/validate_token')).with(
      headers: {
        'access-token': user_token[:access_token],
        'client': user_token[:client],
        'uid': user_token[:uid]
      }
    ).to_return(
      body: {
        success: true,
        data: {
          identifier: identifier
        }
      }.to_json
    )
    user_token
  end
end
