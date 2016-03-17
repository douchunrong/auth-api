require 'rails_helper.rb'

describe AccountSerializer do
  include_context 'user_account'

  it 'serializes parti user account' do
    parti_account = user_account_exists parti: {}
    account_json = ActiveModel::SerializableResource.new(parti_account).to_json
    expect(account_json).to have_json_path('parti')
    expect(account_json).to be_json_eql(<<-JSON)
      {
        "id": "#{parti_account.identifier}",
        "type": "user-account"
      }
    JSON
    .excluding('parti')
  end

  it 'serializes internal user account' do
    internal_account = UserAccount.joins(:internal).take
    account_json = ActiveModel::SerializableResource.new(internal_account).to_json
    expect(account_json).to be_json_eql(<<-JSON)
      {
        "id": "#{internal_account.identifier}",
        "type": "user-account"
      }
    JSON
  end

  it 'serializes null account' do
    null_account = NullAccount.take
    account_json = ActiveModel::SerializableResource.new(null_account).to_json
    expect(account_json).to be_json_eql(<<-JSON)
      {
        "id": "#{null_account.identifier}",
        "type": "null-account"
      }
    JSON
  end
end
