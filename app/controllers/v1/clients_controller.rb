class V1::ClientsController < ApplicationController
  before_action :require_access_token

  def create
    unless current_token.scopes.map(&:name).include?(Scope::CREATE_CLIENT)
      raise Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new
    end

    current_token.account
    client = Client.new(create_client_params)
    client.user_account = current_token.account
    client.save!
    render status: 201, json: client
  end

  private

  def create_client_params
    client_params = params.require :client
    client_params.require :name
    client_params.permit :name, { redirect_uris: [] }
  end
end
