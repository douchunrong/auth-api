module OidcProvider
  module Authentication
    def self.before_filter(*names, &blk)
      # stubbed
    end

    def self.rescue_from(*klasses, &block)
      # stubbed
    end

    def redirect_to(url)
      # stubbed 
    end

    include ::Authentication

    def session
      @session ||= {}
    end
  end
end

RSpec.configure do |config|
  config.include OidcProvider::Authentication
end
