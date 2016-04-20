class AuthorizationSerializer < ActiveModel::Serializer
  attributes :code
  belongs_to :account
end
