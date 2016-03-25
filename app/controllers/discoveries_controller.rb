class DiscoveriesController < ApplicationController
  AUTH_UI_BASE_URL = 'http://localhost:8080'
  AUTH_UI_AUTHORIZATION_ENDPOINT = URI.join(AUTH_UI_BASE_URL, '/authorizations').to_s

  def webfinger
    jrd = {
      links: [{
        rel: OpenIDConnect::Discovery::Provider::Issuer::REL_VALUE,
        href: IdToken.config[:issuer]
      }]
    }
    jrd[:subject] = params[:resource] if params[:resource].present?
    render json: jrd, content_type: Mime[:jrd]
  end

  def openid_configuration
    config = OpenIDConnect::Discovery::Provider::Config::Response.new(
      issuer: IdToken.config[:issuer],
      authorization_endpoint: AUTH_UI_AUTHORIZATION_ENDPOINT,
      token_endpoint: v1_tokens_url,
      userinfo_endpoint: 'http://user_info.url',
      jwks_uri: IdToken.config[:jwks_uri],
      scopes_supported: Scope.all.collect(&:name),
      response_types_supported: Client.available_response_types,
      grant_types_supported: Client.available_grant_types,
      subject_types_supported: [:public],
      id_token_signing_alg_values_supported: [:RS256],
      token_endpoint_auth_methods_supported: ['client_secret_basic', 'client_secret_post'],
      claims_supported: ['sub', 'iss', 'email']
    )
    render json: config
  end
end
