shared_context 'users_api' do
  include PartiUrlHelper

  def users_api_conn
    Faraday.new url: users_api_url
  end
end

