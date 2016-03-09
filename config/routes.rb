Rails.application.routes.draw do
  health_check_routes

  namespace :v1 do
    mount_devise_token_auth_for 'User', at: 'users', skip: [:omniauth_callbacks]
    resources :clients, only: :create do
      resources :test_accounts, path: 'test-accounts'
    end
    resources :authorizations, only: :create
    post 'tokens', to: proc { |env| TokenEndpoint.new.call(env) }
  end
end
