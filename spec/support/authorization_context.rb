shared_context 'authorization' do
  include_context 'helper'

  def authorizations_exist(attrs_set = [{}], **options)
    attrs_defaults = { scopes: [] }
    attrs_from_options = attrs_defaults.merge options.except(:count)
    apply_count_option(attrs_set, options).map do |attrs_in|
      attrs = attrs_from_options.merge(attrs_in)
      auth = FactoryGirl.create(:authorization, attrs.except(:scopes))
      attrs[:scopes].each do |scope|
        scope = Scope.find_by_name scope unless scope.is_a? Scope
        FactoryGirl.create(:authorization_scope, authorization: auth, scope: scope)
      end
      auth
    end
  end

  def request_authorization(attrs = {})
    default_attrs = { response_type: 'code' }
    params = default_attrs.merge attrs.slice(
      :client_id, :nonce, :redirect_uri, :response_type, :scope
    )
    get new_authorization2_path, params
  end

  def authorization_should_be_approved
    expect(last_response).to be_redirect
    code = fetch_auth_code last_response.headers['Location']
    expect(code).to be_valid_oauth_code_of(req_params)
  end

  def user_should_see_approve_form_of(req_params)
    expect(last_response).to be_redirect
    redirect_uri = UriHelper.uri_to_hash last_response.headers['Location']
    approve_form_uri = UriHelper.uri_to_hash new_authorization2_url
    byebug
    expect(redirect_uri.except(:query)).to eq(approve_form_uri.except(:query))
  end
end
