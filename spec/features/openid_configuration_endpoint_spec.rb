require 'rails_helper.rb'

describe 'openid configuration discovery' do
  include_context 'feature'

  it 'responds openid configuration discovery' do
    get '/.well-known/openid-configuration'
    response_should_be_200_ok_json
    config = JSON.parse(last_response.body).transform_keys do |key|
      key.parameterize.underscore.to_sym
    end
    expect(config[:authorization_endpoint]).to be_present
    expect(config[:claims_supported]).to be_present
    expect(config[:id_token_signing_alg_values_supported]).to be_present
    expect(config[:issuer]).to be_present
    expect(config[:jwks_uri]).to be_present
    expect(config[:response_types_supported]).to be_present
    expect(config[:scopes_supported]).to be_present
    expect(config[:subject_types_supported]).to be_present
    expect(config[:token_endpoint]).to be_present
    expect(config[:userinfo_endpoint]).to be_present
  end
end
