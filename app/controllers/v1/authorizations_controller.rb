class V1::AuthorizationsController < ApplicationController
  before_action :authenticate_v1_user!, only: [:create]

  def create
    current_account = find_or_create_parti_account @resource
    endpoint = AuthorizationEndpoint.new current_account
    rack_response = endpoint.call request.env
    respond_as_rack_app(*rack_response)
  end

  def find_or_create_parti_account(user)
    account = Account.joins(:parti).find_by connect_parti: { user_id: user.id }
    unless account
      account = Account.new
      account.build_parti(user: user)
      account.save!
    end
    account
  end

  protected

  def respond_as_rack_app(status, header, response)
    ["WWW-Authenticate"].each do |key|
      headers[key] = header[key] if header[key].present?
    end
    if response.redirect?
      redirect_to header['Location']
    end
  end

  def resource_name
    :user
  end
end
