class ConnectParti < ApplicationRecord
  include PartiUrlHelper
  belongs_to :account, inverse_of: :parti

  validates :identifier, presence: true, uniqueness: true

  def user_info(*args)
    @user_info ||= user_info!(*args)
  end

  def user_info!(access_token:)
    oauth_token = Rack::OAuth2::AccessToken::Bearer.new(
      access_token: access_token.token
    )
    res = oauth_token.get users_api_url("/v1/users/#{identifier}")
    case res.status
      when 200
        user_info = JSON.parse(res.body, symbolize_names: true)
        user_info.slice(:email)
      when 401
        raise UsersApi::Unauthorized
      when 404
        raise UsersApi::NotFound
      else
        raise UsersApi::Unknown
    end
  end
end
