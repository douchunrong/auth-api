require 'factories'

FactoryGirl.define do
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
      parti nil
    end

    after :build do |account, evaluator|
      parti_attrs = evaluator.parti.nil? ? {} : evaluator.parti
      parti_attrs.merge account: account
      account.parti = build :connect_parti, parti_attrs
    end
  end
end
