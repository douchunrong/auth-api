require 'factory_girl'

FactoryGirl.define do
  sequence(:seq) { |n| n }

  factory :client do
    transient do
      seq { generate :seq }
    end
    association :user_account, factory: :user_account_parti
    name { "client-#{seq}" }
    redirect_uris { ["http://redirect-#{seq}.uri"] }
  end

  factory :test_account do
    client
    after :create  do |account|
      unless account.parti || account.internal
        user = FactoryGirl.create :user
        account.create_parti(user: user)
      end
    end
  end

  factory :user do
    transient do
      seq { generate :seq }
      confirm true
    end
    email { "user-#{seq}@email.com" }
    password 'Passw0rd1!'
    after :create  do |user, evaluator|
      if evaluator.confirm
        user.confirm
      end
    end
  end

  factory :user_account do
  end

  factory :user_account_parti, parent: :user_account do
    transient do
      parti {}
    end

    after :build do |account, evaluator|
      user = build :user, evaluator.parti
      account.build_parti user: user
    end

    after :create do |account, evaluator|
      unless evaluator.parti && evaluator.parti[:confirm] === false
        account.parti.user.confirm
      end
    end
  end
end
