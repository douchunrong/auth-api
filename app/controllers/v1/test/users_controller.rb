class V1::Test::UsersController < ApplicationController
  include ::Test::Factories::Users

  before_action :require_access_token

  def index
    users = User.where(index_params)
    render status: 200, json: users
  end

  def index_params
    params.permit :email
  end

  def create
    attrs_set = create_params.to_h[:attrs_set] || [{}]
    users = users_exist attrs_set
    render status: 200, json: users
  end

  def create_params
    params.permit attrs_set: [:email, :password]
  end

  def destroy
    user = User.find params[:id]
    user.destroy
    render :nothing, status: 204
  end
end
