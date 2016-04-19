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
        ENV['AUTH_API_PRIVATE_KEY_BASE64_1'] or raise 'Missing AUTH_API_PRIVATE_KEY_BASE64_1'
        ENV['AUTH_API_PRIVATE_KEY_BASE64_2'] or raise 'Missing AUTH_API_PRIVATE_KEY_BASE64_2'
        ENV['AUTH_API_CERTIFICATE_BASE64'] or raise 'Missing AUTH_API_CERTIFICATE_BASE64'
        pk_base64 = ENV['AUTH_API_PRIVATE_KEY_BASE64_1'] + ENV['AUTH_API_PRIVATE_KEY_BASE64_2']

        config_path = File.join Rails.root, 'config/oidc/id_token'
        @config = YAML.load(ERB.new(File.read(File.join(config_path, 'issuer.yml'))).result)[Rails.env].symbolize_keys
        @config[:jwks_uri] = Rails.application.routes.url_helpers.v1_jwks_url format: :json

        private_key = OpenSSL::PKey::RSA.new(
          Base64.decode64(pk_base64),
          ENV['AUTH_API_PRIVATE_KEY_PASS_PHRASE']
        )
        cert = OpenSSL::X509::Certificate.new(
          Base64.decode64(ENV['AUTH_API_CERTIFICATE_BASE64'])
        )
        issuer_uri = URI.parse @config[:issuer]
        issuer_uri.port = nil if issuer_uri.scheme == 'http' && issuer_uri.port == 80
        issuer_uri.port = nil if issuer_uri.scheme == 'https' && issuer_uri.port == 443
        @config[:issuer] = issuer_uri.to_s
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
