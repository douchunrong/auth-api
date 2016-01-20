shared_context 'user' do
  include_context 'helper'

  def users_exist(attrs_set = [{}], **options)
    apply_count_option(attrs_set, options).map do |attrs|
      FactoryGirl.create(:user, attrs)
    end
  end

  def user_is_not_in_login_status
  end

  def user_is_in_login_status_as(user)
    login_as(user, :scope => :user)
  end

  def user_should_see_login_form
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.url).to eq root_url
  end
end
