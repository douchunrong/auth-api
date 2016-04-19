require 'rails_helper'

describe 'ENV variables', smoke: true do
  describe 'AUTH_API_PRIVATE_KEY_BASE64' do
    it { expect(ENV['AUTH_API_PRIVATE_KEY_BASE64_1']).to be_present }
    it { expect(ENV['AUTH_API_PRIVATE_KEY_BASE64_2']).to be_present }
  end

  describe 'AUTH_API_CERTIFICATE_BASE64' do
    it { expect(ENV['AUTH_API_CERTIFICATE_BASE64']).to be_present }
  end

  describe 'AUTHORIZATION_ENDPOINT' do
    it { expect(ENV['AUTHORIZATION_ENDPOINT']).to be_present }
  end

  describe 'openid issuer' do
    before :each do
      if IdToken.instance_variable_get(:@config)
        IdToken.remove_instance_variable(:@config)
      end
      @auth_api_external_host = ENV['AUTH_API_EXTERNAL_HOST']
      @auth_api_external_port = ENV['AUTH_API_EXTERNAL_PORT']
    end
    after :each do
      ENV['AUTH_API_EXTERNAL_PORT'] = @auth_api_external_port
      ENV['AUTH_API_EXTERNAL_HOST'] = @auth_api_external_host
    end

    it 'has defaults' do
      ENV.delete 'AUTH_API_EXTERNAL_HOST'
      ENV.delete 'AUTH_API_EXTERNAL_PORT'
      expect(IdToken.config[:issuer]).to match(%r{^http://localhost:3030})
    end

    it 'is from ENV' do
      ENV['AUTH_API_EXTERNAL_HOST'] = 'issue-host'
      ENV['AUTH_API_EXTERNAL_PORT'] = '12345'
      expect(IdToken.config[:issuer]).to match(%r{^http://issue-host:12345})
    end

    it 'removes http 80 port from issuer' do
      ENV['AUTH_API_EXTERNAL_HOST'] = 'issue-host'
      ENV['AUTH_API_EXTERNAL_PORT'] = '80'
      expect(IdToken.config[:issuer]).to match(%r{^http://issue-host})
    end
  end
end
