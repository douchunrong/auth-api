class V1::AuthorizationsController < ApplicationController
  include PartiUrlHelper
  # before_action :authenticate_v1_user!, only: [:create]

  def create
    user = validate_user_token
    current_account = find_or_create_parti_account user
    endpoint = AuthorizationEndpoint.new current_account
    rack_response = endpoint.call request.env
    respond_as_rack_app(*rack_response)
  end

  def find_or_create_parti_account(user)
    account = Account.joins(:parti).find_by connect_parti: { identifier: user['identifier'] }
    unless account
      account = UserAccount.new
      account.build_parti(identifier: user['identifier'])
      account.save!
    end
    account
  end

  protected

  def validate_user_token
    headers = request.headers
    ['access-token', 'client', 'uid'].each do |key|
      raise UsersApi::Unauthorized unless headers.key? key
    end

    conn = Faraday.new url: users_api_url
    response = conn.get do |req|
      req.url '/v1/users/validate_token'
      req.headers['access-token'] = headers['access-token']
      req.headers['client'] = headers['client']
      req.headers['uid'] = headers['uid']
    end

    if response.status != 200
      raise UsersApi::Unauthorized
    end

    response_body = JSON.parse response.body
    unless response_body['success']
      raise UsersApi::Unauthorized
    end

    response_body['data']
  end

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
