class ConnectParti < ApplicationRecord
  belongs_to :account, inverse_of: :parti

  validates :identifier, presence: true, uniqueness: true
end
