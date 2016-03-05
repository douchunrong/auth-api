class Client < ApplicationRecord
  PARTI_AUTH_API_TEST_CLIENT_NAME = 'Parti Auth API Test'

  has_many :access_tokens
  belongs_to :account
  serialize :redirect_uris, JSON

  before_validation :setup, on: :create

  validates :identifier, presence: true, uniqueness: true
  validates :secret, presence: true
  validates :name, presence: true

  private

  def setup
    self.identifier = SecureRandom.hex(16)
    self.secret = SecureRandom.hex(32)
  end
end
