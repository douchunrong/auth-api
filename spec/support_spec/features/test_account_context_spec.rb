require 'rails_helper.rb'

describe 'test_account_exists' do
  include_context 'test_account'

  it 'creates test_account record' do
    expect { test_account_exists }.to change { TestAccount.count }.by(1)
  end

  it 'creates valid test_account' do
    test_account = test_account_exists
    verify_test_account test_account
  end

  it 'creates with parti user' do
    test_account = test_account_exists(
      parti: { identifier: 'parti-identifier' }
    )
    expect(test_account.parti.identifier).to eq('parti-identifier')
  end
end

describe 'test_accounts_exist' do
  include_context 'test_account'
  include_context 'client'

  it 'creates one test_account' do
    test_accounts = test_accounts_exist
    expect(test_accounts.size).to eq(1)
    verify_test_account test_accounts.first
  end

  it 'creates two test_accounts' do
    test_accounts = test_accounts_exist [ {}, {} ]
    expect(test_accounts.size).to eq(2)
    test_accounts.each { |test_account| verify_test_account test_account }
  end

  it 'accepts :count option' do
    test_accounts = test_accounts_exist count: 2
    expect(test_accounts.size).to eq(2)
    test_accounts.each { |test_account| verify_test_account test_account }
  end

  it 'accepts :client options' do
    client = client_exists
    test_accounts = test_accounts_exist count: 2, client: client
    test_accounts.each do |account|
      expect(account.client).to eq(client)
    end
  end
end
