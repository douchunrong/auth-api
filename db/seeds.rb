Scope.create [
  {name: 'openid' },
  {name: 'profile'},
  {name: 'email'  },
  {name: 'address'},
  {name: 'phone'}
]
Scope.caches_constants unless defined? Scope::OPENID
