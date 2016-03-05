class ClientSerializer < ActiveModel::Serializer
  attributes :name, :redirect_uris
  attribute :identifier, key: :client_id
  attribute :secret, key: :client_secret
end
