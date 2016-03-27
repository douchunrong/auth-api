require 'test/factories'

module Test::Factories::User
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
    FactoryGirl.create :user, attrs
  end
end
