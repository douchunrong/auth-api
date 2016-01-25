class ApplicationController < ActionController::Base
  include Authentication
  include Notification

  rescue_from HttpError do |e|
    render status: e.status, nothing: true
  end
  rescue_from FbGraph::Exception, Rack::OAuth2::Client::Error do |e|
    redirect_to root_url, flash: {error: e.message}
  end

  protect_from_forgery

  def after_sign_in_path_for(resource)
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end
end
