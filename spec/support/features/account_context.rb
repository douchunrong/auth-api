shared_context 'account' do
  def account_exists(params = {})
    account = FactoryGirl.build(:account) do |a|
      user = FactoryGirl.build(:user)
      a.build_parti(user: user)
    end
    account.save!
    account
  end
end
