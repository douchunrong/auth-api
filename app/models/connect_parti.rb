class ConnectParti < ApplicationRecord
  belongs_to :account, inverse_of: :parti
  belongs_to :user
end
