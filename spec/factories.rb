FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "factory-#{n}@email.com" }
    password "password"
  end

  factory :client do
    sequence(:identifier) { |n| "factory-identifier-#{n}" }
    redirect_uri 'http://redirect-uri.com'
    account
  end

  factory :account do
  end

  factory :authorization_scope do
  end

  factory :authorization do
    sequence(:nonce) { |n| "factory-nonce-#{n}" }
    redirect_uri 'http://redirect-uri.com'
    account
    client
  end
end
