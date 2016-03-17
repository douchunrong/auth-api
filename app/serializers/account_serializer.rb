class AccountSerializer < ActiveModel::Serializer
  attribute :identifier, key: :id
  attributes :type
  def type
    object.type.underscore.dasherize
  end
  has_one :parti do
    object.parti.user if object.parti
  end

  def associations(*args)
    super.reject { |a| object.send(a.name).nil? }
  end
end
