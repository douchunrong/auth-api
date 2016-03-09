class AccountSerializer < ActiveModel::Serializer
  attribute :identifier, key: :id
  attributes :type
  def type
    object.type.underscore.dasherize
  end
  has_one :parti do
    object.parti.user
  end
end
