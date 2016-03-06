shared_context 'user' do
  def user_exists()
    user = FactoryGirl.create(:user)
    account = Account.new
    account.build_parti user: user
    account.save!
    user
  end

  def user_not_exist(params)
    User.where(params).destroy_all
  end

  def user_should_be_created(params)
    last_user = User.last_created
    expect(last_user.email).to eq(params[:email])
    expect(last_user.valid_password? params[:password]).to be true
  end
end
