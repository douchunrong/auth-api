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
      :client_id, :redirect_uri, :response_type
    )
    get new_authorization_path, params
  end

  def authorization_should_be_approved
    expect(last_response).to be_redirect
  end
end