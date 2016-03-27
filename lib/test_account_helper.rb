module TestAccountHelper
  def create_test_account(client:, **attrs)
    FactoryGirl.create :test_account_parti, attrs.merge(client: client)
  end
end
