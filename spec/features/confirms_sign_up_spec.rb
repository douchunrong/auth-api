require 'rails_helper.rb'
require 'uri'

describe 'Confirms sign-up' do
  include_context 'feature'

  it 'succeeds to confirm sign-up' do
    confirmation_link = user_signs_up_then_gets_confirm_link(
      email: 'user@email.com'
    )

    get confirmation_link

    response_should_render_confirmed_sign_up
    user_sign_up_should_be_confirmed(
      email: 'user@email.com',
    )
  end
end
