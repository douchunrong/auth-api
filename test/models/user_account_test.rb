require 'test_helper'

class UserAccountTest < ActiveSupport::TestCase
  test 'validate type is present' do
      account = UserAccount.new
      account.type = nil
      assert_not account.valid?
  end
end

