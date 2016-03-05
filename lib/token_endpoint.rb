class TokenEndpoint
  attr_accessor :app
  delegate :call, to: :app

  def initialize
    @app = Rack::OAuth2::Server::Token.new do |req, res|
      client = Client.find_by(
        identifier: req.client_id,
        secret: req.client_secret
      ) || req.invalid_client!
      case req.grant_type
      when :password
        byebug
        # account = find_account req.username, req.password || req.invalid_grant!
        # account.access_token.create(client: client).to_bearer_token(:with_refresh_token)
      else
        req.unsupported_grant_type!
      end
    end
  end
end
