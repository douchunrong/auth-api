require 'test_helper'

class TestAccountTest < ActiveSupport::TestCase
  test 'validate client is present' do
    account = TestAccount.new
    assert_not account.valid?
  end
end

