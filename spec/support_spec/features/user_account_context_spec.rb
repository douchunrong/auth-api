require 'rails_helper.rb'

describe 'user_account_exists' do
  include_context 'user_account'

  it 'creates user_account record' do
    expect { user_account_exists }.to change { UserAccount.count }.by(1)
  end

  it 'creates valid user_account' do
    user_account = user_account_exists
    verify_user_account user_account
  end

  it 'creates with parti user' do
    user_account = user_account_exists(
      parti: { user: { email: 'user@email.com' } }
    )
    expect(user_account.parti.user.email).to eq('user@email.com')
  end
end

describe 'user_accounts_exist' do
  include_context 'user_account'

  it 'creates one user_account' do
    user_accounts = user_accounts_exist
    expect(user_accounts.size).to eq(1)
    verify_user_account user_accounts.first
  end

  it 'creates two user_accounts' do
    user_accounts = user_accounts_exist [ {}, {} ]
    expect(user_accounts.size).to eq(2)
    user_accounts.each { |user_account| verify_user_account user_account }
  end

  it 'accepts :count option' do
    user_accounts = user_accounts_exist count: 2
    expect(user_accounts.size).to eq(2)
    user_accounts.each { |user_account| verify_user_account user_account }
  end
end

describe 'user_accounts_not_exist' do
  include_context 'user_account'

  it 'removes existing user_account' do
    user_account = user_account_exists

    user_accounts_not_exist(
      parti: { email: user_account.parti.user.email }
    )

    user_accounts_should_not_exist(
      id: user_account.id
    )
  end

  it 'removes two existing user_accounts' do
    user_accounts  = user_accounts_exist count: 2

    user_accounts_not_exist(
      user: { email: user_accounts.map { |a| a.parti.user.email } }
    )

    user_accounts_should_not_exist(
      id: user_accounts.map(&:id)
    )
  end
end
