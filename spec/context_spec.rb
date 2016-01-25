describe 'user_exists' do
  include_context 'user'

  it 'returns User' do
    expect( user_exists ).to be_a User
  end

  it 'create User with email' do
    user = user_exists(email: 'valid@email.com')
    expect( user.email ).to eq('valid@email.com')
  end

  it 'create User with password' do
    user = user_exists(password: 'any-string')
    expect( user.valid_password?('any-string') ).to be true
  end
end

describe 'users_exist' do
  include_context 'user'

  subject { lambda { |*args| users_exist(*args) } }
  it_behaves_like '*_exist factory'
end

describe 'authorizations_exist' do
  include_context 'authorization'

  subject { lambda { |*args| authorizations_exist(*args) } }
  it_behaves_like '*_exist factory'

  it 'handles scopes attr' do
    scope = Scope.create name: 'scope-for-test'
    auth, * = authorizations_exist({
      scopes: [ scope ]
    })
    expect(auth.scopes).to contain_exactly(scope)
  end

  it 'handles scopes attr with string' do
    scope = Scope.create name: 'scope-for-test'
    auth, * = authorizations_exist({
      scopes: [ 'scope-for-test' ]
    })
    expect(auth.scopes).to contain_exactly(scope)
  end
end
