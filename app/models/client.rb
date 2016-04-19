class Client < ApplicationRecord
  AUTH_API_TEST_CLIENT_NAME = 'Auth API Test'
  AUTH_EXAMPLE_CLIENT_NAME = 'Auth Example'
  AUTH_UI_CLIENT_NAME = 'Auth UI'
  AUTH_UI_TEST_CLIENT_NAME = 'Auth UI Test'
  CANOE_WEB_CLIENT_NAME = 'Canoe Web'
  CANOE_MOBILE_CLIENT_NAME = 'Canoe Mobile'
  OMNIAUTH_TEST_CLIENT_NAME = 'Omniauth Test'
  USERS_API_TEST_CLIENT_NAME = 'Users API Test'
  USERS_UI_TEST_CLIENT_NAME = 'Users UI Test'
  USERS_UI_CLIENT_NAME = 'Users UI'

  belongs_to :user_account
  has_many :test_accounts, inverse_of: :client
  has_many :access_tokens
  has_many :authorizations
  serialize :redirect_uris, JSON

  before_validation :setup, on: :create

  validates :identifier, presence: true, uniqueness: true
  validates :secret, presence: true
  validates :name, presence: true

  class << self
    def available_response_types
      ['code']
    end

    def available_grant_types
      ['authorization_code']
    end
  end

  private

  def setup
    self.identifier = SecureRandom.hex(16)
    self.secret = SecureRandom.hex(32)
  end
end
