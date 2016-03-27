require 'rails_helper'

shared_context 'user' do
  include PartiUrlHelper
  include_context 'sign_up'

  def user_not_exist(attrs)
    User.where(attrs).destroy_all
  end

  def user_token_exists(identifier:)
    user_token = {
      access_token: 'access_token',
      client: 'client',
      uid: 'uid',
    }
    stub_request(:get, users_api_url('/v1/users/validate_token')).with(
      headers: {
        'access-token': user_token[:access_token],
        'client': user_token[:client],
        'uid': user_token[:uid]
      }
    ).to_return(
      body: {
        success: true,
        data: {
          identifier: identifier
        }
      }.to_json
    )
    user_token
  end

  def user_should_be_created(params)
    last_user = User.createds.last
    expect(last_user.email).to eq(params[:email])
    expect(last_user.valid_password? params[:password]).to be true
  end

  def user_should_be_deleted(params)
    users = User.where(params)
    expect(users).to be_empty
  end

  def users_should_be_created(params)
    if params[:count]
      expect(User.createds.size).to eq(params[:count])
    end
    if params[:attrs_set]
      User.createds.zip(params[:attrs_set]).each do |user, attrs|
        expect(user.attributes.symbolize_keys.slice(*attrs.keys)).to eq(attrs)
      end
    end
  end

  def users_should_not_exist(attrs)
    expect(User.where attrs).to be_empty
  end

  def response_should_render_users(users)
    expect(last_response.status).to eq(200)
    users_json = ActiveModel::SerializableResource.new(users).to_json
    expect(last_response.body).to be_json_eql(users_json)
  end

  def response_should_be_render_created_users
    expect(last_response.status).to eq(200)
    users_json = ActiveModel::SerializableResource.new(User.createds).to_json
    expect(last_response.body).to be_json_eql(users_json)
  end
end
