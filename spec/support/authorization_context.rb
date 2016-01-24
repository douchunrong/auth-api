shared_context 'authorization' do
  include_context 'client'
  include_context 'helper'
  include_context 'user'

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

  def request_authorization_code_by_user(attrs = {})
    default_attrs = { response_type: 'code' }
    params = default_attrs.merge attrs.slice(
      :client_id, :nonce, :redirect_uri, :response_type, :scope
    )
    visit new_authorization_path(params)
  end

  def user_should_see_approve_form
    expect(page).to have_button('approve')
  end

  def user_is_at_authorization_approval_form(req_params)
    request_authorization_code_by_user req_params
    user_should_see_approve_form
  end

  def approve_authorization_request_by_user
    user_should_see_approve_form
    do_not_follow_redirect do
      click_button 'approve'
    end
  end

  def user_should_be_redirected_with_authorization_code_of(req_params)
    expect([301, 302, 303, 307]).to be_include page.status_code
    code = fetch_auth_code page.response_headers['Location']
    expect(code).to be_valid_oauth_code_of(req_params)
  end

  def authorization_is_granted
    user, * = users_exist
    client_is_in_parti_login_status_as user
    client, * = registered_clients_exist
    post authorizations_path(
        client_id: client.identifier,
        nonce: "nonce-#{client.identifier}",
        redirect_uri: client.redirect_uris.first,
        response_type: 'code',
        scope: 'openid',
        state: "state-#{client.identifier}",
        approve: true
    )
    expect(last_response).to be_redirect
    query = UriHelper.uri_to_hash(last_response.headers['location'])[:query]
    URI::decode_www_form(query)
      .to_h
      .symbolize_keys
      .merge client: client
  end
end
