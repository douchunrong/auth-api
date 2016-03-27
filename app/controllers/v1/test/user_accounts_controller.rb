class V1::Test::UserAccountsController < ApplicationController
  include ::Test::Factories::UserAccount

  before_action :require_access_token

  def index
    where = index_params[:where]
    parti_attrs = where[:parti]
    if parti_attrs
      accounts = UserAccount.joins(:parti).where(connect_parti: parti_attrs)
    else
      accounts = UserAccount.where where
    end
    render status: 200, json: accounts
  end

  def index_params
    where_json = params[:where] || '{}'
    begin
      where = JSON.parse(where_json)
    rescue JSON::ParserError
      raise ActionController::BadRequest.new 'Invalid json format for where parameter'
    end
    nparams = ActionController::Parameters.new where: where
    { where: nparams.fetch(:where).permit([:id, :identifier, parti: [:email]]).to_h.compact }
  end

  def create
    attrs_set = create_params.to_h[:attrs_set] || [{}]
    accounts = user_accounts_exist attrs_set
    render status: 200, json: accounts
  end

  def create_params
    params.permit attrs_set: [parti: [:identifier]]
  end

  def destroy
    account = UserAccount.find_by_identifier! destory_params[:identifier]
    account.destroy
    render :nothing, status: 204
  end

  def destory_params
    params.permit :identifier
  end

  def create_token
    identifier, scope_names = create_token_params.values_at :identifier, :scopes
    account = UserAccount.find_by_identifier! identifier
    token = account.access_tokens.build client: current_token.client
    scopes = scope_names.map do |name|
      Scope.find_by_name! name
    end
    token.scopes << scopes
    account.save!
    render status: 200, json: token
  end

  def create_token_params
    params.permit :identifier, scopes: []
  end
end
