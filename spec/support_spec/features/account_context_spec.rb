require 'rails_helper.rb'

describe 'account_exists' do
  include_context 'account'

  it 'creates account record' do
    expect { account_exists }.to change { Account.count }.by(1)
  end

  it 'creates valid account' do
    account = account_exists
    verify_account account
  end

  it 'creates with parti user' do
    account = account_exists(
      parti: { user: { email: 'user@email.com' } }
    )
    expect(account.parti.user.email).to eq('user@email.com')
  end
end

describe 'accounts_exist' do
  include_context 'account'

  it 'creates one account' do
    accounts = accounts_exist
    expect(accounts.size).to eq(1)
    verify_account accounts.first
  end

  it 'creates two accounts' do
    accounts = accounts_exist [ {}, {} ]
    expect(accounts.size).to eq(2)
    accounts.each { |account| verify_account account }
  end

  it 'accepts :count option' do
    accounts = accounts_exist count: 2
    expect(accounts.size).to eq(2)
    accounts.each { |account| verify_account account }
  end
end

describe 'accounts_not_exist' do
  include_context 'account'

  it 'removes existing account' do
    account = account_exists

    accounts_not_exist(
      parti: { email: account.parti.user.email }
    )

    accounts_should_not_exist(
      id: account.id
    )
  end

  it 'removes two existing accounts' do
    accounts  = accounts_exist count: 2

    accounts_not_exist(
      user: { email: accounts.map { |a| a.parti.user.email } }
    )

    accounts_should_not_exist(
      id: accounts.map(&:id)
    )
  end
end
