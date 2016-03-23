require 'rails_helper.rb'

describe 'webfinger discovery' do
  include_context 'feature'

  it 'responds webfinger discovery' do
    get '/.well-known/webfinger'
    response_should_be_200_ok
    expect(last_response.body).to be_json_eql(<<-JSON)
      {
        "links":[
          {
            "rel": "http://openid.net/specs/connect/1.0/issuer",
            "href": "#{IdToken.config[:issuer]}"
          }
        ]
      }
    JSON
  end
end
