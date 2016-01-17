module BeValidOauthAuthRespUrlOfMatcher
  class BeValidOauthAuthRespUrlOfMatcher
    def initialize(req_uri)
      @req = UriHelper.uri_to_hash req_uri
    end

    def matches?(resp_uri)
      req_params = URI::decode_www_form(@req[:query]).to_h
      redirect = UriHelper.uri_to_hash req_params['redirect_uri']
      resp = UriHelper.uri_to_hash resp_uri
      if (redirect.except(:query) != resp.except(:query)) 
        @failure_message = "Unexpected response #{resp_uri}!"
        return
      end

      resp_params = URI::decode_www_form(resp[:query]).to_h
      if (req_params['state'] != resp_params['state'])
        @failure_message = "Unexpected state #{resp_params['state']}!"
        return
      end
      if resp_params['code'].blank?
        @failure_message = "Unexpected empty code!"
      end
      true
    end

    def failure_message
      @failure_message
    end
  end

  def be_valid_oauth_auth_resp_url_of(resp_uri)
    BeValidOauthAuthRespUrlOfMatcher.new resp_uri
  end
end

RSpec.configure do |config|
    config.include BeValidOauthAuthRespUrlOfMatcher
end
