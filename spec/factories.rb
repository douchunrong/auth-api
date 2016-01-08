FactoryGirl.define do

  factory :client do
    sequence(:identifier) { |n| "factory-identifier-#{n}" }
    redirect_uri 'http://redirect-uri.com'
    account
  end

  factory :account do
  end

end
