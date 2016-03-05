shared_context 'auth' do
  def token_is_granted(params)
    access_token = params[:account].access_tokens.create(:client => params[:client])
    if params[:scope]
      access_token.scopes << Scope.where('name IN (?)', params[:scope].split)
    end
    access_token.token
  end
end
