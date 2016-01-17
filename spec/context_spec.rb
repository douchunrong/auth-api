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
