class AccountSerializer < ActiveModel::Serializer
  attribute :identifier
  attributes :type
  def type
    object.type.underscore.dasherize
  end
  has_one :parti

  def associations(*args)
    super.reject { |a| object.send(a.name).nil? }
  end
end
