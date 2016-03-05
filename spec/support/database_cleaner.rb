RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    load "#{Rails.root}/db/seeds.rb"
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
    load "#{Rails.root}/db/seeds.rb"
  end
end
