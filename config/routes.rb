Rails.application.routes.draw do
  health_check_routes

  namespace :v1 do
    mount_devise_token_auth_for 'User', at: 'users', skip: [:omniauth_callbacks]
    resources :clients, only: :create do
      resources :test_accounts, path: 'test-accounts' do
        delete :index, on: :collection, action: :delete_all
      end
    end
    resources :authorizations, only: :create
    post 'tokens', to: proc { |env| TokenEndpoint.new.call(env) }
    post 'introspect', to: 'tokens#introspect'

    if Rails.env.test?
      namespace :test do
        resources :users, only: [:index, :create, :destroy] do
          post 'verify-password', on: :member, to: 'users#verify_password'
        end
        resources :user_accounts, only: [:index, :create, :destroy],
                  path: 'user-accounts', param: :identifier do
          post 'tokens', on: :member, to: 'user_accounts#create_token'
        end
        post 'database/clean', to: 'database#clean'
      end
    end
  end
end
