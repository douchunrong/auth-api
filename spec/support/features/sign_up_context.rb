shared_context 'sign_up' do
  def response_should_render_created_user
    last_user = User.last_created
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
    confirmation_token = User.last_created.confirmation_token
    expect(last_email).to have_body_text("confirmation_token=#{confirmation_token}")
  end
end
