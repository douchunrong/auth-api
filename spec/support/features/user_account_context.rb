shared_context 'user_account' do
  def user_accounts_exist(attrs_set = [{}], **options)
    if options[:count]
      attrs_set = attrs_set.cycle.take(options[:count])
    end
    attrs_set.map do |attrs|
      user_account_exists attrs
    end
  end

  def user_account_exists(attrs = {})
    FactoryGirl.create(:user_account, attrs.except(:parti)) do |account|
      if attrs[:parti]
        if attrs[:parti][:user]
          user = FactoryGirl.create :user, attrs[:parti][:user]
          account.create_parti account: account, user: user
        end
      end
    end
  end

  def user_accounts_not_exist(attrs)
    users = User.where(attrs[:parti])
    Account.joins(:parti)
      .where(connect_parti: { user_id: users.pluck(:id) })
      .destroy_all
  end

  def user_accounts_should_not_exist(attrs)
    expect(Account.where(attrs)).to be_empty
  end

  def verify_user_account(user_account)
    connect_sum = [user_account.parti, user_account.internal].map { |c| c.nil? ? 0 : 1 }.inject(0, :+)
    expect(connect_sum).to eq(1)
  end
end
