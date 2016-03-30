require 'rails_helper'

describe 'ENV variables', smoke: true do
  describe 'AUTH_API_PRIVATE_KEY_BASE64' do
    it { expect(ENV['AUTH_API_PRIVATE_KEY_BASE64']).to be_present }
  end

  describe 'AUTH_API_CERTIFICATE_BASE64' do
    it { expect(ENV['AUTH_API_CERTIFICATE_BASE64']).to be_present }
  end
end
