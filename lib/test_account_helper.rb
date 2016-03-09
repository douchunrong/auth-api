module TestAccountHelper
  def create_test_account(client:, password: Faker::Internet.password)
    user = User.new(
      email: Faker::Internet.email,
      password: password
    )
    account = TestAccount.new client: client
    account.build_parti user: user
    account.transaction do
      user.save!
      user.update confirmed_at: user.created_at
      account.save!
    end
    account
  end
end
