def auth_api_url()
  return "http://#{auth_api_host}:#{auth_api_port}"
end

def auth_api_host()
  return ENV['AUTH_API_HOST'] || 'localhost'
end

def auth_api_port()
  return ENV['AUTH_API_PORT'] || 3030
end
