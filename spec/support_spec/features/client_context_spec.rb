require 'rails_helper.rb'

describe 'client_exists' do
  include_context 'client'
  include_context 'user_account'

  it 'creates client record' do
    expect { client_exists }.to change { Client.count }.by(1)
  end

  it 'creates valid client' do
    client = client_exists
    expect(client.identifier).not_to be_blank
    expect(client.secret).not_to be_blank
    expect(client.redirect_uris).not_to be_empty
    verify_user_account(client.user_account)
  end

  it 'creates with account' do
    user_account = user_account_exists
    client = client_exists user_account: user_account
    expect(client.user_account).to eql(user_account)
  end
end
