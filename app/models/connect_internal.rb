class ConnectInternal < ApplicationRecord
  PARTI_AUTH_INTERNAL_NAME = 'Parti Auth Internal'

  belongs_to :account, inverse_of: :internal
end
