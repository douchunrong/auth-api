class Test::ClientsController < ApplicationController
  include ::Test::Factories::Client
  before_action :require_access_token

  def create
    client = client_exists create_params.to_h
    render status: 201, json: client
  end

  def create_params
    params.permit :name, redirect_uris: []
  end
end
