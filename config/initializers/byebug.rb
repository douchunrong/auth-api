require 'byebug/core'

if ENV['RUBY_DEBUG_PORT']
  Byebug.wait_connection = true
  Byebug.start_server 'localhost', ENV['RUBY_DEBUG_PORT'].to_i
end
