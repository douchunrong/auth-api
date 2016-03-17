class V1::Test::UserAccountsController < ApplicationController
  include ::Test::Factories::UserAccount

  before_action :require_access_token

  def index
    where = index_params
    if where.empty?
      accounts = []
    else
      parti_attrs = where[:parti]
      if parti_attrs
        accounts = UserAccount.joins(parti: :user).where(users: parti_attrs)
      else
        accounts = UserAccount.where where
      end
    end
    render status: 200, json: accounts
  end

  def index_params
    where = {}
    if params[:where]
      begin
        where = JSON.parse(params[:where])
      rescue JSON::ParserError
        raise ActionController::BadRequest.new 'Invalid json format for where parameter'
      end
    end
    new_params = ActionController::Parameters.new where: where
    new_params.require(:where).permit(:id, :identifier, parti: [:email]).to_h.compact
  end

  def create
    attrs_set = create_params.to_h[:attrs_set] || [{}]
    accounts = user_accounts_exist attrs_set
    render status: 200, json: accounts
  end

  def create_params
    params.permit attrs_set: [parti: [:email, :password]]
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
    account = UserAccount.find_by_identifier! create_token_params[:identifier]
    token = account.access_tokens.build client: current_token.client
    scopes = create_token_params[:scope].split(' ').map do |scope_name|
      Scope.find_by_name! scope_name
    end
    token.scopes << scopes
    account.save!
    render status: 200, json: token
  end

  def create_token_params
    params.permit :identifier, :scope
  end
end
