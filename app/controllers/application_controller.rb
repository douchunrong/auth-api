class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Concerns::Authentication

  rescue_from ActionController::BadRequest, :with => :bad_request
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def bad_request(error)
    render json: { error: error.message }, status: :bad_request
  end

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end
end
