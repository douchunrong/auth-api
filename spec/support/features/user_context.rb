require 'factory_girl'

FactoryGirl.define do
  factory :user do
  end
end

def user_exists()
  FactoryGirl.create(:user)
end
