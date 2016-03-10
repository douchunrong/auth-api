class TokenEndpoint
  attr_accessor :app
  delegate :call, to: :app

  def initialize
    @app = Rack::OAuth2::Server::Token.new do |req, res|
      client = Client.find_by_identifier(req.client_id) || req.invalid_client!
      client.secret == req.client_secret || req.invalid_client!
      case req.grant_type
      when :authorization_code
        authorization = client.authorizations.valid.find_by_code(req.code)
        req.invalid_grant! if authorization.blank? || !authorization.valid_redirect_uri?(req.redirect_uri)
        access_token = authorization.access_token
        res.access_token = access_token.to_bearer_token
        if access_token.accessible?(Scope.find_by_name(Scope::OPENID))
          res.id_token = access_token.account.id_tokens.create!(
            client: access_token.client,
            nonce: authorization.nonce
          ).to_jwt
        end
      when :client_credentials
        res.access_token = client.access_tokens.create(account: NullAccount.take).to_bearer_token
      else
        req.unsupported_grant_type!
      end
    end
  end
end
