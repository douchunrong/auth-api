class V1::UserInfoController < ApplicationController
  before_action :require_access_token

  def show
    current_account = current_token.account
    user_info = current_account.user_info access_token: current_token
    render status: 200, json: user_info
  end
end
