module PartiAuth
  class IdToken < OpenIDConnect::ResponseObject::IdToken
    attr_optional :email, :nickname
  end
end
