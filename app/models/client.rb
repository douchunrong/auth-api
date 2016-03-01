class Client < ApplicationRecord
  belongs_to :account
  serialize :redirect_uris, JSON
end
