class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :password, :created_at

  def attributes(*args)
    data = super
    if object.password.nil?
      data = data.except(:password)
    end
    data
  end
end
