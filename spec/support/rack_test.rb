# To fix inconsistent host name in test.
module Rack
  module Test
    DEFAULT_HOST = 'www.example.com' # wish to be URI.parse(root_uri).host
  end
end
