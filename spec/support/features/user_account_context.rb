shared_context 'user_account' do
  include Test::Factories::UserAccount

  def user_account_exists(attrs = {})
    email = attrs.dig :parti, :email
    if email
      user_accounts_not_exist parti: { email: email }
    end
    super attrs
  end

  def user_accounts_not_exist(attrs)
    if attrs[:parti]
      users = User.where(attrs[:parti])
    else
      users = User.none
    end
    UserAccount.joins(:parti)
      .where(connect_parti: { user_id: users.pluck(:id) })
      .destroy_all
    users.destroy_all
  end

  def user_accounts_should_not_exist(attrs)
    expect(UserAccount.where(attrs)).to be_empty
  end

  def verify_user_account(user_account)
    connect_sum = [user_account.parti, user_account.internal].map { |c| c.nil? ? 0 : 1 }.inject(0, :+)
    expect(connect_sum).to eq(1)
  end
end
