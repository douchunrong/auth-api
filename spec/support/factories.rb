FactoryGirl.define do
  sequence(:seq) { |n| n }

  factory :account do
    after(:build) do |account|
      unless account.parti || account.internal
        user = FactoryGirl.build :user
        account.build_parti(user: user)
      end
    end

    after(:create) do |account|
      unless account.parti || account.internal
        user = FactoryGirl.create :user
        account.create_parti(user: user)
      end
    end
  end

  factory :client do
    transient do
      seq { generate :seq }
    end
    account
    name { "client-#{seq}" }
    redirect_uris { ["http://redirect-#{seq}.uri"] }
  end

  factory :user do
    sequence(:email) { |n| "user-#{n}@email.com" }
    password 'Passw0rd1!'
  end
end
