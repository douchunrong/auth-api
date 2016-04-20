class Test::AuthCodesController < ApplicationController
  include ::Test::Factories::UserAccount
  before_action :require_access_token

  def create
    account_attrs, client_id, nonce, redirect_uri, scope_names = create_params.to_h.values_at(
      :account, :client_id, :nonce, :redirect_uri, :scopes
    )
    client = Client.find_by_identifier! client_id
    account = user_account_exists account_attrs
    authorization = account.authorizations.create!(
      client: client,
      nonce: nonce,
      redirect_uri: redirect_uri
    )
    scopes = scope_names.map { |name| Scope.find_by_name(name) }.compact
    authorization.scopes << scopes

    render status: 200, json: authorization
  end

  def create_params
    params.permit :client_id, :nonce, :redirect_uri, scopes: [], account: [ parti: [ :identifier ] ]
  end
end
