shared_context 'user_account' do
  include Test::Factories::UserAccount

  def user_account_exists(attrs = {})
    user_accounts_not_exist(attrs)
    super attrs
  end

  def user_accounts_not_exist(attrs)
    parti_attrs = attrs[:parti] ? attrs[:parti] : {}
    UserAccount.joins(:parti)
      .where(connect_parti: parti_attrs)
      .destroy_all
  end

  def user_accounts_should_not_exist(attrs)
    expect(UserAccount.where(attrs)).to be_empty
  end

  def verify_user_account(user_account)
    connect_sum = [user_account.parti, user_account.internal].map { |c| c.nil? ? 0 : 1 }.inject(0, :+)
    expect(connect_sum).to eq(1)
  end
end
