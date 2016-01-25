shared_context 'user' do
  include_context 'helper'

  def user_exists(attrs = {})
    FactoryGirl.create(:user, attrs)
  end

  def users_exist(attrs_set = [{}], **options)
    apply_count_option(attrs_set, options).map do |attrs|
      user_exists(attrs)
    end
  end

  def user_is_not_in_login_status
    unauthenticate!
    page.set_rack_session session
  end

  def user_is_in_parti_login_status_as(user)
    login_as(user, :scope => :user)
    authenticate Connect::Parti.authenticate
    logged_in!
    page.set_rack_session session
  end

  def user_should_be_asked_parti_sign_in
    expect(page.current_path).to eq(new_user_session_path)
    expect(page).to have_button('Log in')
  end

  def user_should_be_asked_to_login
    expect(page).to have_button('Create Fake Account')
  end
end
