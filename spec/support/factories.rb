FactoryGirl.define do
  factory :account
end

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@email.com" }
    password 'Passw0rd1!'
  end
end
