class V1::UsersController < ApplicationController
  before_action :require_access_token

  def index
    users = User.where(index_params)
    render status: 200, json: users
  end

  def index_params
    params.permit :email
  end

end
