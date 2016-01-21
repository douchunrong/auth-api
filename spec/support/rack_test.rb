# To fix inconsistent host name in test.
module Rack
  module Test
    DEFAULT_HOST = 'www.example.com' # wish to be URI.parse(root_uri).host
  end
end

module RackSessionAccess
  module RackTest
    def set_rack_session(hash)
      data = ::RackSessionAccess.encode(hash)
      put RackSessionAccess.path, data: data
      assert last_response.redirect?
      follow_redirect!
      assert last_response.body.include?('Rack session data')
    end

    def get_rack_session
      get ::RackSessionAccess.path + '.raw'
      assert last_response.ok?
      raw_data = Nokogiri::HTML(last_response.body).at('body pre').text
      ::RackSessionAccess.decode(raw_data)
    end

    def get_rack_session_key(key)
      get_rack_session.fetch(key)
    end
  end
end

Rack::Test::Methods.send :include, RackSessionAccess::RackTest

module ApiHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end
end

RSpec.configure do |config|
  config.include ApiHelper
end
