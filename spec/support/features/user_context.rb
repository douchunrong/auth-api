require 'factory_girl'

FactoryGirl.define do
  factory :user do
    email 'user@email.com'
    password 'Passw0rd1!'
  end
end

def user_exists()
  FactoryGirl.create(:user)
end
