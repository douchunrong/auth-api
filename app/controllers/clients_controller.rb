class ClientsController < ApplicationController
  before_action :authenticate

  def create
    parti = ConnectParti.find_by! user: current_user
    account = Account.joins(:parti).find_by!(connect_parti: { id: parti.id })
    client = Client.new(client_params)
    client.account = account
    client.save!
  end

  def authenticate
    auth_header = request.headers['Authorization']
    user_id = /Bearer temp-free-pass-for-(\d+)/.match(auth_header)[1]
    @current_user = User.find user_id
  end

  def current_user
    @current_user
  end

  private

  def client_params
    params.require(:client).permit(redirect_uris: [])
  end
end
