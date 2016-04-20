require 'rails_helper'

describe AuthorizationSerializer do
  include_context 'authorization'
  include_context 'client'
  include_context 'user_account'

  it 'serializes authorization' do
    account = user_account_exists
    client = client_exists
    authorization = authorization_code_is_granted(
      account: account,
      client: client,
      scopes: [ Scope::OPENID ],
      nonce: 'nonce-random'
    )
    auth_data = ActiveModel::SerializableResource.new(authorization).as_json
    expect(auth_data.to_json).to be_json_eql(<<-JSON).excluding('account')
      {
        "code": "#{authorization.code}"
      }
    JSON
    # Active Modle Serializer does not support nested association at this moment.
    # account_json = ActiveModel::SerializableResource.new(account).to_json
    # expect(auth_data[:account].to_json).to be_json_eql(account_json)
  end
end
