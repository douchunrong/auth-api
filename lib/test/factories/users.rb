require 'test/factories/factory_girl'

module Test::Factories::Users
  def users_exist(attrs_set = [{}], **options)
    if options[:count]
      attrs_set = attrs_set.cycle.take(options[:count])
    end
    attrs_options = options.except(:count)
    attrs_set.map do |attrs|
      user_exists attrs_options.merge(attrs)
    end
  end

  def user_exists(attrs = {})
    user_attrs = attrs.except :unconfirmed
    FactoryGirl.create :user, user_attrs do |user|
      user.confirmed_at = Time.now unless attrs[:unconfirmed]
      user.save!
    end
  end
end
