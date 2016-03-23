require 'rails_helper.rb'

describe 'jwks endpoint' do
  include_context 'feature'

  it 'responds jwks' do
    get '/v1/jwks.json'
    expect(last_response.body).to be_json_eql(IdToken.config[:jwk_set].to_json)
  end
end
