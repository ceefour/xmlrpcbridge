#!/usr/bin/env ruby
# LICENSE: LGPLv3

require 'rubygems'
require 'xmlrpc/server'

$LOAD_PATH << 'lib'
require 'unfuddle'

unless ARGV.size >= 4
  puts "Usage: ruby server.rb ACCOUNT USERNAME PASSWORD PROJECT_NAME" 
  exit
end

server_port = (ENV['XMLRPCSERVER_PORT'] || 8080).to_i
server = XMLRPC::Server.new(server_port)
trap('INT') { server.shutdown }

account = Unfuddle::AccountProxy.new(ARGV[0], ARGV[1], ARGV[2])
project = account.project.get_by_short_name(ARGV[3])
ticket = account.ticket(project['id'])
ticket_interface = XMLRPC::interface('ticket') {
  meth 'array query(string)', 'Query tickets and return ticket IDs'
  meth 'array get(id)', 'Get ticket detail'
}
server.add_handler ticket_interface, ticket

puts "Server URL: http://localhost:#{server_port}/"
puts "Test using irb:"
puts "  require 'xmlrpc/client'"
puts "  proxy = XMLRPC::Client.new2('http://localhost:#{server_port}/')"
puts "  proxy.call('ticket.query', 'status!=closed')"
puts "  proxy.call('ticket.get', 1)"
server.serve
