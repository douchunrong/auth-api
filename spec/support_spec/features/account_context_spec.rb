require 'rails_helper.rb'

describe 'account_context' do
  include_context 'account'

  it 'inserts account' do
    expect { account_exists }.to change{ Account.count }.by(1)
  end

  it 'creates parti account' do
    account = account_exists
    expect(account.parti.user).not_to be_new_record
  end
end
