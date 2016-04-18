# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

null_account = NullAccount.take
unless null_account
  null_account = NullAccount.new
  null_account.build_internal name: ConnectInternal::NULL_NAME
  null_account.save!
end

internal_account = UserAccount.joins(:internal).find_by connect_internals: { name: ConnectInternal::INTERNAL_NAME }
unless internal_account
  internal_account = UserAccount.new
  internal_account.build_internal name: ConnectInternal::INTERNAL_NAME
  internal_account.save!
end

unless Client.find_by user_account: internal_account, name: Client::AUTH_API_TEST_CLIENT_NAME
  client = Client.create!(
    user_account: internal_account,
    name: Client::AUTH_API_TEST_CLIENT_NAME,
    redirect_uris: ''
  )
  client.update(
    identifier: '45d3ab6922c7e2a0c8cc2a5b19080658',
    secret: '58a17ba804daa8011c3c2e4db2df0ea203eb1341fad6bd116d67eceebf580826'
  )
end

unless Client.find_by user_account: internal_account, name: Client::AUTH_UI_CLIENT_NAME
  client = Client.create!(
    name: Client::AUTH_UI_CLIENT_NAME,
    redirect_uris: [],
    user_account: internal_account,
  )
  client.update(
    identifier: 'a839a637cc38f01e42aec485b65da5ea',
    secret: '307f53a54ad061995556c977b428c11c75ef181c3ad868cffc173cd9e48aaced',
  )
end

unless Client.find_by user_account: internal_account, name: Client::AUTH_UI_TEST_CLIENT_NAME
  client = Client.create!(
    name: Client::AUTH_UI_TEST_CLIENT_NAME,
    redirect_uris: '',
    user_account: internal_account,
  )
  client.update(
    identifier: '64b14471f5a3aaacce1f13a801367d6d',
    secret: '2556d3de7c2fc40a1b6bd0b2e8e6261c80f00f6a62426fc0de7d6a6a6551159c'
  )
end

unless Client.find_by user_account: internal_account, name: Client::AUTH_EXAMPLE_CLIENT_NAME
  client = Client.create!(
    name: Client::AUTH_EXAMPLE_CLIENT_NAME,
    redirect_uris: [
      'http://rp.auth.parti.xyz/auth/parti/callback',
      'http://rp.auth.parti.xyz/parti_callback',
      'http://rp.auth.parti.dev/auth/parti/callback',
      'http://rp.auth.parti.dev/parti_callback'
    ],
    user_account: internal_account,
  )
  client.update(
    identifier: '14b54b09ac8087b73e8a83be58ed8293',
    secret: '8a61e801e69e31cba8d358dd560b30b64e1db995450d9dd0399e195462155b9a'
  )
end

unless Client.find_by user_account: internal_account, name: Client::USERS_API_TEST_CLIENT_NAME
  client = Client.create!(
    name: Client::USERS_API_TEST_CLIENT_NAME,
    redirect_uris: [],
    user_account: internal_account,
  )
  client.update(
    identifier: '46e506ea5125e2dd202d6318687d5d24',
    secret: 'a0171ed5e691cd444f1f3a164b278228612ffb690b2176b7f13f82f8f23af06b'
  )
end

unless Client.find_by user_account: internal_account, name: Client::USERS_UI_CLIENT_NAME
  client = Client.create!(
    name: Client::USERS_UI_CLIENT_NAME,
    redirect_uris: [],
    user_account: internal_account,
  )
  client.update(
    identifier: '3536acd7c4178ce2c8963361c73d57b4',
    secret: 'e9efd649d02591f42015de807e052689941a0c683a473626c47f5ef111af48b8'
  )
end

unless Client.find_by user_account: internal_account, name: Client::USERS_UI_TEST_CLIENT_NAME
  client = Client.create!(
    name: Client::USERS_UI_TEST_CLIENT_NAME,
    redirect_uris: [],
    user_account: internal_account,
  )
  client.update(
    identifier: 'a248e649e8563f0d8a1eaa255f8c05ae',
    secret: 'd5b1378e5854309c1d6e76d7e2c77dbee4bb3f1cab745f7e94cbc8370dea2460'
  )
end

unless Client.find_by user_account: internal_account, name: Client::CANOE_WEB_CLIENT_NAME
  client = Client.create!(
    name: Client::CANOE_WEB_CLIENT_NAME,
    redirect_uris: [
      'http://canoe.parti.xyz/auth/parti/callback',
      'https://canoe.parti.xyz/auth/parti/callback',
      'http://canoe.parti.dev/auth/parti/callback',
      'https://canoe.parti.dev/auth/parti/callback'
    ],
    user_account: internal_account,
  )
  client.update(
    identifier: 'cee1f144d7cc141ef72e64f53020d6c2',
    secret: '83a387c214903b5335001876421f538f7153ce5fc051cb0ae213ca1355900f6d'
  )
end

unless Client.find_by user_account: internal_account, name: Client::CANOE_MOBILE_CLIENT_NAME
  client = Client.create!(
    name: Client::CANOE_MOBILE_CLIENT_NAME,
    redirect_uris: [
      'http://canoe.parti.xyz/auth/parti/callback',
      'https://canoe.parti.xyz/auth/parti/callback',
      'http://canoe.parti.dev/auth/parti/callback',
      'https://canoe.parti.dev/auth/parti/callback'
    ],
    user_account: internal_account,
  )
  client.update(
    identifier: '22505d317d96111d414f20161f3956f6',
    secret: '12a45288f61339459405c630376fd237928b236eab968d62861c18a3c7049217'
  )
end

['openid', 'profile', 'email', 'create_client'].each do |name|
  unless Scope.find_by name: name
    Scope.create! name: name
  end
end
