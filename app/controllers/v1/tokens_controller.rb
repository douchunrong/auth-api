class V1::TokensController < ApplicationController
  before_action :require_access_token

  def introspect
    token_param = introspect_params[:token]
    if current_token.token == token_param
      token_model = AccessToken.find_by_token! token_param
      introspection = {
        active: token_model.expires_at >= Time.now,
        exp: token_model.expires_at.to_i,
        scope: token_model.scopes.map(&:name).join(' '),
        token_type: 'bearer'
      }
      if token_model.account.kind_of? NullAccount
        introspection.merge!(
          grant_type: 'client_credentials',
          sub: token_model.client.identifier,
        )
      else
        introspection.merge!(
          grant_type: 'authorization_code',
          connect_id: token_model.account.connect_id,
          connect_type: token_model.account.connect_type,
          sub: token_model.account.identifier,
        )
      end
    else
      introspection = { active: false }
    end
    render status: 200, json: introspection
  end

  def introspect_params
    params.require :token
    params.permit :token
  end
end
