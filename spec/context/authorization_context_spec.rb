describe 'authorizations_exist' do
  include_context 'authorization'

  subject { lambda { |*args| authorizations_exist(*args) } }
  it_behaves_like '*_exist factory'

end
