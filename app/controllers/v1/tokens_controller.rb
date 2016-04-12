class V1::TokensController < ApplicationController
  before_action :require_access_token

  def introspect
    token_param = introspect_params[:token]
    if current_token.token == token_param
      token_model = AccessToken.find_by_token! token_param
      introspection = {
        active: token_model.expires_at >= Time.now,
        connect_id: token_model.account.connect_id,
        connect_type: token_model.account.connect_type,
        exp: token_model.expires_at.to_i,
        scope: token_model.scopes.map(&:name).join(' '),
        sub: token_model.account.identifier,
        token_type: 'bearer'
      }
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
