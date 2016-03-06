require 'rails_helper.rb'

describe 'User signs up' do
  include_context 'feature'

  before(:all) do
    Devise.mailer.deliveries.clear
  end

  it 'succeeds to sign up' do
    user_not_exist email: 'user@email.com'

    request_sign_up(
      email: 'user@email.com',
      password: 'Passw0rd!',
      password_confirmation: 'Passw0rd!'
    )
    response_should_render_created_user
    user_should_be_created(
      email: 'user@email.com',
      password: 'Passw0rd!'
    )
    confirmation_email_should_be_sent(
      email: 'user@email.com'
    )
  end
end
