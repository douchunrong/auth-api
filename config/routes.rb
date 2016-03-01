Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  health_check_routes

  scope(path: '/v1') do
    resources :clients, only: :create
  end
end
