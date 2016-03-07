require 'rails_helper.rb'

describe 'client_exists' do
  include_context 'client'
  include_context 'account'

  it 'creates client record' do
    expect { client_exists }.to change { Client.count }.by(1)
  end

  it 'creates valid client' do
    client = client_exists
    expect(client.identifier).not_to be_blank
    expect(client.secret).not_to be_blank
    expect(client.redirect_uris).not_to be_empty
    verify_account(client.account)
  end

  it 'creates with account' do
    account = account_exists
    client = client_exists account: account
    expect(client.account).to eql(account)
  end
end
