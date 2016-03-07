class Authorization < ApplicationRecord
  belongs_to :account
  belongs_to :client
  has_and_belongs_to_many :scopes

  before_validation :setup, on: :create

  validates :account,    presence: true
  validates :client,     presence: true
  validates :code,       presence: true, uniqueness: true
  validates :expires_at, presence: true

  scope :valid, lambda {
    where('expires_at >= ?', Time.now.utc)
  }

  private

  def setup
    self.code = SecureRandom.hex(32)
    self.expires_at = 5.minutes.from_now
  end
end
