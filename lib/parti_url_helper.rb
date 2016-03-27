module PartiUrlHelper
  def auth_api_url()
    return "http://#{auth_api_host}:#{auth_api_port}"
  end

  def auth_api_host()
    return ENV['AUTH_API_HOST'] || 'localhost'
  end

  def auth_api_port()
    return ENV['AUTH_API_PORT'] || 3030
  end

  def users_api_url(path = '/')
    base_url = "http://#{users_api_host}:#{users_api_port}"
    URI::join(base_url, path).to_s
  end

  def users_api_host()
    return ENV['USERS_API_HOST'] || 'users-api.dev'
  end

  def users_api_port()
    return ENV['USERS_API_PORT'] || 80
  end
end
