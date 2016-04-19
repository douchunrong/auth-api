require 'token_endpoint'

Rails.application.routes.draw do
  health_check_routes

  get '.well-known/openid-configuration', to: 'discoveries#openid_configuration'
  get '.well-known/webfinger', to: 'discoveries#webfinger'

  if Rails.env.test?
    namespace :test do
      resources :auth_codes, only: [:create], path: 'auth-codes'
      resources :clients, only: [:create]
    end
  end

  namespace :v1 do
    resources :clients, only: :create do
      resources :test_accounts, path: 'test-accounts' do
        delete :index, on: :collection, action: :delete_all
      end
    end
    resources :authorizations, only: :create
    get 'user-info', to: 'user_info#show'
    post 'introspect', to: 'tokens#introspect'
    get  'jwks', to: proc { |env| [200, {'Content-Type' => 'application/json'}, [IdToken.config[:jwk_set].to_json]] }
    post 'tokens', to: proc { |env| TokenEndpoint.new.call(env) }

    if Rails.env.test?
      namespace :test do
        resources :user_accounts, only: [:index, :create, :destroy],
                  path: 'user-accounts', param: :identifier do
          post 'tokens', on: :member, to: 'user_accounts#create_token'
        end
        post 'database/clean', to: 'database#clean'
      end
    end
  end
end
