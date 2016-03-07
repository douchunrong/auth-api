class Account < ApplicationRecord
  has_one :parti, class_name: 'ConnectParti', inverse_of: :account
  has_one :internal, class_name: 'ConnectInternal', inverse_of: :account
  has_many :clients
  has_many :authorizations
  has_many :access_tokens
end
