shared_context 'sign_up' do
  def user_signs_up_then_gets_confirm_link(params)
    attrs = FactoryGirl.attributes_for(:user)
    sign_up_params = attrs.merge(password_confirmation: attrs[:password]).merge(params)
    request_sign_up sign_up_params
    email_confirmation_link
  end

  def email_confirmation_link
    last_email = Devise.mailer.deliveries.last
    uris = URI.extract(last_email.body.to_s)
    uris.select { |u| URI(u).path =~ %r|#{v1_user_confirmation_path}| }.first
  end

  def request_sign_up(params)
    post '/v1/users', params
  end

  def response_should_render_created_user
    last_user = User.createds.last
    expect(last_response.status).to eq(200)
    expect(last_response.body).to be_json_eql(<<-JSON)
    {
      "status": "success",
      "data": {
        "id": "#{last_user.id}",
        "provider": "email",
        "uid":"user@email.com",
        "name":null,
        "nickname":null,
        "image":null,
        "email":"user@email.com"
      }
    }
    JSON
  end

  def confirmation_email_should_be_sent(params)
    last_email = Devise.mailer.deliveries.last
    expect(last_email).to deliver_to(params[:email])
    confirmation_token = User.createds.last.confirmation_token
    expect(last_email).to have_body_text("confirmation_token=#{confirmation_token}")
  end

  def response_should_render_confirmed_sign_up
    expect(last_response.status).to eq(302)
    redirect_uri = URI(last_response.headers['Location'])
    params = Hash[URI::decode_www_form(redirect_uri.query)]
    expect(params['token']).not_to be_blank
    expect(params['expiry']).not_to be_blank
    expect(params['client_id']).not_to be_blank
    expect(params['account_confirmation_success']).to eq('true')
  end

  def user_sign_up_should_be_confirmed(params)
    user = User.find_by(params)
    expect(user.confirmed_at).not_to be nil
    expect(user.tokens).not_to be_blank
  end
end
