module TokenHelper
  def basic_auth_credential(id, secret)
    ["#{id}:#{secret}"].pack('m').tr("\n", '')
  end
end
