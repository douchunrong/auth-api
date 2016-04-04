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

  factory :user_account do
  end

  factory :test_account do
    client
  end

  factory :test_account_parti, parent: :test_account do
    transient do
      parti nil
    end

    after :build do |account, evaluator|
      parti_attrs = evaluator.parti.nil? ? {} : evaluator.parti
      parti_attrs.merge account: account
      account.parti = build :connect_parti, parti_attrs
    end
  end

  factory :connect_parti do
    transient do
      seq { generate :seq }
    end
    association :account, factory: :user_account, strategy: :build
    identifier { "identifier-#{seq}" }
  end

  factory :user_account_parti, parent: :user_account do
    transient do
      parti nil
    end

    after :build do |account, evaluator|
      parti_attrs = evaluator.parti.nil? ? {} : evaluator.parti
      parti_attrs.merge account: account
      account.parti = build :connect_parti, parti_attrs
    end
  end
end
