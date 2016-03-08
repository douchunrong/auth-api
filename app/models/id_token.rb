class IdToken < ApplicationRecord
  belongs_to :account
  belongs_to :client

  before_validation :setup, on: :create

  validates :account, presence: true
  validates :client,  presence: true

  scope :valid, lambda {
    where { expires_at >= Time.now.utc }
  }

  def to_response_object
    OpenIDConnect::ResponseObject::IdToken.new(
      iss: self.class.config[:issuer],
      sub: account.identifier,
      aud: client.identifier,
      nonce: nonce,
      exp: expires_at.to_i,
      iat: created_at.to_i
    )
  end

  def to_jwt
    to_response_object.to_jwt(self.class.config[:private_key]) do |jwt|
      jwt.kid = self.class.config[:kid]
    end
  end

  private

  def setup
    self.expires_at = 1.hours.from_now
  end

  class << self
    def decode(id_token)
      OpenIDConnect::ResponseObject::IdToken.decode id_token, config[:public_key]
    rescue => e
      logger.error e.message
      nil
    end

    def config
      unless @config
        config_path = File.join Rails.root, 'config/oidc/id_token'
        @config = YAML.load_file(File.join(config_path, 'issuer.yml'))[Rails.env].symbolize_keys
        @config[:jwks_uri] = File.join(@config[:issuer], 'jwks.json')
        private_key = OpenSSL::PKey::RSA.new(
          File.read(File.join(config_path, 'private.key')),
          'pass-phrase'
        )
        cert = OpenSSL::X509::Certificate.new(
          File.read(File.join(config_path, 'cert.pem'))
        )
        @config[:kid] = :default
        @config[:public_key] = cert.public_key
        @config[:private_key] = private_key
        @config[:jwk_set] = JSON::JWK::Set.new(
          JSON::JWK.new(cert.public_key, use: :sig, kid: @config[:kid])
        )
      end
      @config
    end
  end
end
