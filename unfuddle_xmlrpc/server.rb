#!/usr/bin/env ruby
# LICENSE: LGPLv3
require 'rubygems'
require 'xmlrpc/server'
require 'webrick'

$LOAD_PATH << 'lib'
require 'unfuddle'

server_port = (ENV['XMLRPCSERVER_PORT'] || 8080).to_i
server = WEBrick::HTTPServer.new(:Port => server_port) # XMLRPC::Server.new(server_port)
require 'unfuddle_servlet'
server.mount('/', UnfuddleServlet)
server.mount('/secure', UnfuddleServlet, {:secure => true})
trap('INT') { server.shutdown }

puts "Server URL: http://localhost:#{server_port}/ACCOUNT/PROJECT/"
puts "Test using irb:"
puts "  require 'xmlrpc/client'"
puts "  proxy = XMLRPC::Client.new2('http://USER:PASS@localhost:#{server_port}/ACCOUNT/PROJECT/')"
puts "  proxy.call('ticket.query', 'status!=closed')"
puts "  proxy.call('ticket.get', 1)"
server.start
