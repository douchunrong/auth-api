Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  health_check_routes

  namespace :v1 do
    resources :clients, only: :create
    post 'tokens', to: proc { |env| TokenEndpoint.new.call(env) }
  end
end
