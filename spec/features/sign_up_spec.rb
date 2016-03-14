require 'rails_helper.rb'

describe 'Sign up' do
  include_context 'feature'

  before(:all) do
    Devise.mailer.deliveries.clear
  end

  it 'sign up with password confirmation' do
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

  it 'sign up without password confirmation' do
    user_not_exist email: 'user@email.com'

    request_sign_up(
      email: 'user@email.com',
      password: 'Passw0rd!'
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

  it 'sign up with different password confirmation' do
    user_not_exist email: 'user@email.com'

    request_sign_up(
      email: 'user@email.com',
      password: 'Passw0rd!',
      password_confirmation: 'different password'
    )
    response_should_be_422_unprocessable_entity
  end
end
