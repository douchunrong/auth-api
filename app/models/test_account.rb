class TestAccount < Account
  belongs_to :client, inverse_of: :test_accounts

  validates :client, presence: true
end
