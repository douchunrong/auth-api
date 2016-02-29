require 'rails_helper.rb'

describe 'user_exists' do
  it 'creates user' do
    expect {
      user_exists()
    }.to change{ User.count }.by(1)
  end

  it 'is okay to call twice' do
    user_exists()
    user_exists()
  end
end
