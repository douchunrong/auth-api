shared_context 'sign_in' do
  def sign_in(email:, password:)
    post v1_user_session_path,
      email: email,
      password: password
  end

  def sign_in_as(user)
    User.class_eval do
      alias_method :orig_valid_password?, :valid_password?

      def valid_password?(password)
        encrypted_password == password
      end
    end
    begin
      sign_in(
        email: user.email,
        password: user.encrypted_password
      )
    ensure
      User.class_eval do
        alias_method :valid_password?, :orig_valid_password?
        remove_method :orig_valid_password?
      end
    end
  end
end
