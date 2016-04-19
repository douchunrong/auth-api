require 'factories'

module Test::Factories::Client
  def client_exists(attrs = {})
    FactoryGirl.create :client, attrs
  end
end
