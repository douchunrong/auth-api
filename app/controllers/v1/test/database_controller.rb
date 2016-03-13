class V1::Test::DatabaseController < ApplicationController
  before_action :require_access_token

  def clean
    DatabaseCleaner.clean_with(:truncation)
    load "#{Rails.root}/db/seeds.rb"
    render :nothing, status: 204
  end
end
