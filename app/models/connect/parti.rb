class Connect::Parti < ActiveRecord::Base
  belongs_to :account
  belongs_to :user

  def userinfo
    OpenIDConnect::ResponseObject::UserInfo.new(
      email:  user.email
    )
  end

  class << self
    def authenticate(user)
      parti = create! user: user
      Account.create! parti: parti
    end
  end
end
