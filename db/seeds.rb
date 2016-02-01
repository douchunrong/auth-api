Scope.create [
  {name: 'openid' },
  {name: 'profile'},
  {name: 'email'  },
  {name: 'address'},
  {name: 'phone'}
]
Scope.caches_constants unless defined? Scope::OPENID

user = User.create! :name => 'Parti Admin', :email => 'admin@parti.xyz', :password => 'Passw0rd!', :password_confirmation => 'Passw0rd!'
account = Connect::Parti.authenticate user
client = account.clients.create(
  native: false,
  ppid: true,
  name: 'parti client',
  redirect_uris: 'http://omniauth.dev/auth/parti/callback',
)
client.identifier = '7615cf67ce5e15a31ee008b32e16e5d9'
client.secret = '8374b5d387ef4116aea442137dd112c2a0648669999a1a53c9f965e9c1111dba'
client.save
