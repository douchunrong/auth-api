class DiscoveriesController < ApplicationController
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
      authorization_endpoint: ENV['AUTHORIZATION_ENDPOINT'],
      token_endpoint: v1_tokens_url,
      userinfo_endpoint: v1_user_info_url,
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
