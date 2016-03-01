require 'rails_helper.rb'

describe 'user_exists' do
  it 'creates user' do
    expect {
      user_exists()
    }.to change{ User.count }.by(1)
  end

  it 'has assocication to account' do
    user = user_exists()
    parti = ConnectParti.find_by! user: user
    expect(parti).not_to be_nil
    account = Account.joins(:parti).find_by!(connect_parti: { id: parti.id })
    expect(account).not_to be nil
  end

  it 'is okay to call twice' do
    user_exists()
    user_exists()
  end
end
