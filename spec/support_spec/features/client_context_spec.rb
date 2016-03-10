require 'rails_helper.rb'

describe 'client_exists' do
  include_context 'client'
  include_context 'user_account'

  it 'creates client record' do
    expect { client_exists }.to change { Client.count }.by(1)
  end

  it 'creates valid client' do
    client = client_exists
    expect(client).to be_valid
    expect(client.redirect_uris).not_to be_empty
    verify_user_account(client.user_account)
  end

  it 'creates with account' do
    user_account = user_account_exists
    client = client_exists user_account: user_account
    expect(client.user_account).to eql(user_account)
  end
end

describe 'clients_exist' do
  include_context 'client'

  it 'creates one client' do
    clients = clients_exist
    expect(clients.size).to eq(1)
    expect(clients.first).to be_valid
    expect(clients.first.redirect_uris).not_to be_empty
  end

  it 'creates two clients' do
    clients = clients_exist [ {}, {} ]
    expect(clients.size).to eq(2)
    clients.each do |client|
      expect(client).to be_valid
      expect(client.redirect_uris).not_to be_empty
    end
  end

  it 'accepts :count option' do
    clients = clients_exist count: 2
    expect(clients.size).to eq(2)
    clients.each do |client|
      expect(client).to be_valid
      expect(client.redirect_uris).not_to be_empty
    end
  end
end
