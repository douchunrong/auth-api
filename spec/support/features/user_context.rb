shared_context 'user' do
  def user_exists()
    user = FactoryGirl.create(:user)
    account = Account.new
    account.build_parti user: user
    account.save!
    user
  end
end
