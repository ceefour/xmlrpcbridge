#!/usr/bin/env ruby
# LICENSE: LGPLv3
require 'rubygems'
require 'xmlrpc/server'
require 'webrick'
require 'webrick/https'  # Note: Requires Ruby/OpenSSL
require 'socket' # gethostname

$LOAD_PATH << 'lib'
require 'unfuddle'

# configuration
server_port = (ENV['XMLRPCSERVER_PORT'] || 8080).to_i
secure_port = (ENV['XMLRPCSERVER_SECUREPORT'] || 8081).to_i

# init servers
server1 = WEBrick::HTTPServer.new(:Port => server_port) # XMLRPC::Server.new(server_port)
server2 = WEBrick::HTTPServer.new(
  :Port            => secure_port,
  :SSLEnable       => true,
  :SSLVerifyClient => ::OpenSSL::SSL::VERIFY_NONE,
  :SSLCertName => [ ["C","ID"], ["O","soluvas.com"], ["CN", "xmlrpcbridge"] ]
)

# trap interrupt (Ctrl+C)
trap('INT') {
  server1.shutdown
  server2.shutdown
}

# display instructions
hostname = Socket.gethostname
puts "Server URL:"
puts "  http://#{hostname}:#{server_port}/ACCOUNT/PROJECT/"
puts "  https://#{hostname}:#{secure_port}/ACCOUNT/PROJECT/"
puts "Server URL for HTTPS Unfuddle accounts:"
puts "  http://#{hostname}:#{server_port}/ACCOUNT/PROJECT/"
puts "  https://#{hostname}:#{secure_port}/secure/ACCOUNT/PROJECT/"
puts "Test using irb:"
puts "  require 'xmlrpc/client'"
puts "  proxy = XMLRPC::Client.new2('http://USER:PASS@localhost:#{server_port}/ACCOUNT/PROJECT/')"
puts "  proxy.call('ticket.query', 'status!=closed')"
puts "  proxy.call('ticket.get', 1)"

# start servers
require 'unfuddle_servlet'
thread1 = Thread.start(server1) { |server|
  server.mount('/', UnfuddleServlet)
  server.mount('/secure', UnfuddleServlet, {:secure => true})
  server.start
}
thread2 = Thread.start(server2) { |server|
  server.mount('/', UnfuddleServlet)
  server.mount('/secure', UnfuddleServlet, {:secure => true})
  server.start
}

# wait until completion
thread1.join
thread2.join