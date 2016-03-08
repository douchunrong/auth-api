require 'rails_helper.rb'

describe 'user_exists' do
  include_context 'user'

  it 'creates user record' do
    expect { user_exists }.to change{ User.count }.by(1)
  end

  it 'creates unconfirmed' do
    Timecop.freeze do
      user = user_exists confirm: false
      expect(user.confirmation_token).not_to be_blank
      expect(user.confirmation_sent_at).to eq(Time.now)
      expect(user.tokens).to be_blank
      expect(user.created_at).to eq(Time.now)
      expect(user.updated_at).to eq(Time.now)
    end
  end

  it 'creates confirmed user by default' do
    Timecop.freeze do
      user = user_exists
      expect(user.tokens).not_to be_blank
      expect(user.updated_at).to eq(Time.now)
    end
  end

  it 'is okay to call twice' do
    user_exists()
    user_exists()
  end

  it 'creates with email' do
    user = user_exists email: 'any@email.com'
    expect(user.email).to eq('any@email.com')
  end
end

describe 'user_auth_token_exists' do
  include_context 'user'

  it 'returns user_auth_token' do
    auth_token = user_auth_token_exists
    expect(auth_token[:access_token]).not_to be_blank
    expect(auth_token[:client]).not_to be_blank
    expect(auth_token[:uid]).not_to be_blank
  end
end
