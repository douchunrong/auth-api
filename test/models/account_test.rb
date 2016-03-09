require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test 'Account.new raises error' do
    assert_raises RuntimeError do
      Account.new
    end
  end
end
