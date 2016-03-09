require 'test_helper'

class UserAccountTest < ActiveSupport::TestCase
  test 'validation fails when type is nil' do
      account = UserAccount.new
      account.type = nil
      assert_not account.valid?
  end
end

