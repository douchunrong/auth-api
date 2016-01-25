class Connect::PartiController < ApplicationController
  before_filter :require_anonymous_access
  before_filter :authenticate_user!

  def show
    authenticate Connect::Parti.authenticate
    logged_in!
  end
end
