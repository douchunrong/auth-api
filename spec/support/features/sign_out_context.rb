shared_context 'sign_out' do
  def sign_out(token:)
    header 'uid', token[:uid]
    header 'access-token', token[:access_token]
    header 'client', token[:client]
    delete destroy_v1_user_session_path
  end
end
