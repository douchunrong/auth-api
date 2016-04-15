RSpec.configure do |config|
  config.before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
    load "#{Rails.root}/db/seeds.rb"
  end
end
