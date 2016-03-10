
class V1::TestAccountsController < ApplicationController
  include TestAccountHelper

  before_action :require_access_token

  def create
    unless current_token.client.identifier == params[:client_id]
      raise Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new
    end
    test_account = create_test_account client: current_token.client
    render status: 201, json: test_account
  end

  def delete_all
    client = Client.find_by_identifier! params[:client_id]
    unless current_token.client == client
      raise Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new
    end
    current_token.client.test_accounts.destroy_all
    render :nothing, :status => 204
  end
end
