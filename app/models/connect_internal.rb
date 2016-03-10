class ConnectInternal < ApplicationRecord
  INTERNAL_NAME = 'Internal'
  NULL_NAME = 'Null'

  belongs_to :account, inverse_of: :internal
end
