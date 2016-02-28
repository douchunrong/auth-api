require 'faraday'
require_relative 'support/url_helper.rb'

describe '/health_check', smoke: true do
  it 'responds ok with success' do
    conn = Faraday.new(url: auth_api_url)
    resp = conn.get('/health_check')
    expect(resp.status).to eq(200)
    expect(resp.body).to eq('success')
  end
end
