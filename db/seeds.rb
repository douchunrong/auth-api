# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

account = ConnectInternal.find_by name: ConnectInternal::PARTI_AUTH_INTERNAL_NAME
unless account
  account = Account.new
  account.build_internal name: ConnectInternal::PARTI_AUTH_INTERNAL_NAME
  account.save!
end

unless Client.find_by account: account, name: Client::PARTI_AUTH_API_TEST_CLIENT_NAME
  Client.create! account: account, name: Client::PARTI_AUTH_API_TEST_CLIENT_NAME
end

['openid', 'profile', 'email', 'create_client'].each do |name|
  unless Scope.find_by name: name
    Scope.create! name: name
  end
end
