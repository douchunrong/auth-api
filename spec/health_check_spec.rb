require 'rails_helper'

describe '/check', smoke: true do
  it 'responds ok' do
    get '/health_check'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('success')
  end
end
