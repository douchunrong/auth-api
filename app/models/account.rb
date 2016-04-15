class Account < ApplicationRecord
  has_one :parti, class_name: 'ConnectParti', inverse_of: :account, dependent: :destroy
  has_one :internal, class_name: 'ConnectInternal', inverse_of: :account, dependent: :destroy
  has_many :authorizations
  has_many :access_tokens
  has_many :id_tokens

  before_validation :setup, on: :create
  validates :identifier, length: { minimum: 0, allow_nil: false }, uniqueness: true
  validates :type, presence: true

  def initialize(*args)
    raise "Cannot directly instantiate a #{self.class}" if self.class == Account
    super
  end

  def user_info(*args)
    (parti || internal).user_info(*args)
  end

  def connect_type
    return 'parti' if parti
    return 'internal' if internal
    return ''
  end

  def connect_id
    return parti.identifier if parti
    return internal.name if internal
    return ''
  end

  private

  def setup
    self.identifier = SecureRandom.hex(8)
  end
end
