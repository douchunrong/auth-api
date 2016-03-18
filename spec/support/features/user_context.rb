shared_context 'user' do
  include Test::Factories::User
  include_context 'sign_up'

  def user_not_exist(attrs)
    User.where(attrs).destroy_all
  end

  def user_auth_token_exists(email:, password:)
    post v1_user_session_path,
      email: email,
      password: password
    expect(last_response.status).to eq(200)
    last_response.headers.slice('access-token', 'client', 'uid')
      .transform_keys { |key| key.parameterize.underscore.to_sym }
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
