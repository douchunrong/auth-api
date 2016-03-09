class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :password, :created_at
end
