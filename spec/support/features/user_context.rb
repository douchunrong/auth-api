require 'factory_girl'

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@email.com" }
    password 'Passw0rd1!'
  end
end

def user_exists()
  FactoryGirl.create(:user)
end
