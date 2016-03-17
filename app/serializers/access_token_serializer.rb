class AccessTokenSerializer < ActiveModel::Serializer
  attributes :token_type, :expires_in
  attribute :token, key: :access_token

  def token_type
    'Bearer'
  end

  def expires_in
    (object.expires_at - Time.now.utc).to_i
  end
end
