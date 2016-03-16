class V1::Test::UserAccountsController < ApplicationController
  include ::Test::Factories::UserAccount

  before_action :require_access_token

  def create
    attrs_set = create_params.to_h[:attrs_set] || [{}]
    accounts = user_accounts_exist attrs_set
    render status: 200, json: accounts
  end

  def create_params
    params.permit attrs_set: [parti: [:email]]
  end
end
