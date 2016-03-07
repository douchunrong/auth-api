class AuthorizationEndpoint
  attr_accessor :app
  delegate :call, to: :app

  def initialize(current_account)
    @app = Rack::OAuth2::Server::Authorize.new do |req, res|
      client = Client.find_by_identifier(req.client_id) || req.bad_request!
      res.redirect_uri = req.verify_redirect_uri! client.redirect_uris

      if req.response_type != :code
        req.invalid_request! 'only respose_type=code is supported'
      end
      if res.protocol_params_location == :fragment && req.nonce.blank?
        req.invalid_request! 'nonce required'
      end
      scopes = req.scope.inject([]) do |a, scope|
        a << (Scope.find_by_name(scope) or req.invalid_scope! "Unknown scope: #{scope}")
      end

      authorization = current_account.authorizations.create!(
        client: client,
        nonce: req.nonce,
        redirect_uri: res.redirect_uri
      )
      authorization.scopes << scopes
      res.code = authorization.code
      res.approve!
    end
  end
end
