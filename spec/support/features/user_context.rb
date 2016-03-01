require 'factory_girl'

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@email.com" }
    password 'Passw0rd1!'
  end
end

def user_exists()
  user = FactoryGirl.create(:user)
  account = Account.new
  account.build_parti user: user
  account.save!
  user
end
