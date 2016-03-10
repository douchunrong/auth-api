require 'test_helper'

class NullAccountTest < ActiveSupport::TestCase
  test 'it should exist' do
    assert NullAccount.take.present?
  end

  test 'it should be unique' do
    assert_raises ActiveRecord::RecordInvalid do
      NullAccount.create!
    end
  end
end
