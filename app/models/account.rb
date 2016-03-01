class Account < ApplicationRecord
  has_one :parti, class_name: 'ConnectParti', inverse_of: :account
  has_many :clients
end
