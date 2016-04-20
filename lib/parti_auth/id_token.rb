module PartiAuth
  class IdToken < OpenIDConnect::ResponseObject::IdToken
    attr_optional :email, :nickname

    def self.decode(jwt_string, key)
      new JSON::JWT.decode jwt_string, key
    end
  end
end
