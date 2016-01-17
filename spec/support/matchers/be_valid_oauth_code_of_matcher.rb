module BeValidOauthCodeOfMatcher
  class BeValidOauthCodeOfMatcher
    def initialize(req_params)
      @req_params = req_params
    end

    def matches?(code)
      auth = Authorization.find_by_code(code)
      if auth.client.identifier != @req_params[:client_id]
        @failure_message = "Unexpected client id #{@req_params[:client_id]}"
        return false
      end
      if auth.nonce != @req_params[:nonce]
        @failure_message = "Unexpected nonce #{@req_params[:nonce]}"
        return false
      end
      if auth.redirect_uri != @req_params[:redirect_uri]
        @failure_message = "Unexpected redirct_uri #{@req_params[:redirct_uri]}"
        return false
      end
      if auth.scopes.map(&:name) != @req_params[:scope].split(' ')
        @failure_message = "Unexpected scope #{@req_params[:scope]}"
        return false
      end 
      @failure_message_when_negated = "Unexpected valid code #{code}"
      true
    end

    def failure_message
      @failure_message
    end

    def failure_message_when_negated
      @failure_message_when_negated
    end
  end

  def be_valid_oauth_code_of(req_params)
    BeValidOauthCodeOfMatcher.new req_params
  end
end

RSpec.configure do |config|
    config.include BeValidOauthCodeOfMatcher
end
