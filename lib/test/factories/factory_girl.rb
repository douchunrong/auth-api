require 'factory_girl'

FactoryGirl.define do
  sequence(:seq) { |n| n }

  factory :client do
    transient do
      seq { generate :seq }
    end
    user_account
    name { "client-#{seq}" }
    redirect_uris { ["http://redirect-#{seq}.uri"] }
  end

  factory :test_account do
    client
    after(:create) do |account|
      unless account.parti || account.internal
        user = FactoryGirl.create :user
        account.create_parti(user: user)
      end
    end
  end

  factory :user do
    transient do
      seq { generate :seq }
      confirmed true
    end
    email { "user-#{seq}@email.com" }
    password 'Passw0rd1!'
    after(:create) do |user, evaluator|
      if evaluator.confirmed
        user.confirm
      end
    end
  end

  factory :user_account do
    after(:create) do |account|
      unless account.parti || account.internal
        user = FactoryGirl.create :user
        account.create_parti(user: user)
      end
    end
  end
end
