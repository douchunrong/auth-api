shared_context 'authorization' do

  def request_authorization(attrs = {})
    default_attrs = { response_type: 'code' }
    params = default_attrs.merge attrs.slice(
      :client_id, :redirect_uri, :response_type
    )
    get new_authorization_path, params
  end

end
