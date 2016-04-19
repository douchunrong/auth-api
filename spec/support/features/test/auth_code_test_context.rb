shared_context 'auth_code_test' do
  def issue_auth_code_for_test(token: nil, **attrs)
    if token
        header 'Authorization', "Bearer #{token}"
    end
    post test_auth_codes_path, attrs.to_json, 'CONTENT_TYPE' => 'application/json'
  end

  def auth_code_should_be_rendered
    response_should_be_200_ok
    { code: last_response.body }
  end

  def auth_code_should_be_issued(code:, **attrs)
    auth_model = Authorization.valid.find_by_code! code
    if attrs[:account]
      expect(attrs[:account]).to eq(auth_model.account)
    end
    if attrs[:client]
      expect(attrs[:client]).to eq(auth_model.client)
    end
    if attrs[:redirect_uri]
      expect(attrs[:redirect_uri]).to eq(auth_model.redirect_uri)
    end
    if attrs[:nonce]
      expect(attrs[:nonce]).to eq(auth_model.nonce)
    end
    if attrs[:scopes]
      expect(attrs[:scopes]).to eq(auth_model.scopes.map(&:name))
    end
  end
end
