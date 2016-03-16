require 'test/factories/factory_girl'

module Test::Factories::UserAccount
  def user_accounts_exist(attrs_set = [{}], **options)
    if options[:count]
      attrs_set = attrs_set.cycle.take(options[:count])
    end
    attrs_options = options.except(:count)
    attrs_set.map do |attrs|
      user_account_exists attrs_options.merge(attrs)
    end
  end

  def user_account_exists(attrs = {})
    FactoryGirl.create :user_account_parti, attrs
  end
end
