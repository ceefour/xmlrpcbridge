Unfuddle XML-RPC adapter
========================

This library provides Trac XML-RPC adapter for Unfuddle projects.

Starting the server:

./server.rb

This will start the server on port 8080 (Ctrl+C to shutdown).
To change the port, set and export the environment variable XMLRPCSERVER_PORT.

[2008-03-30 21:10:18] INFO  WEBrick 1.3.1
[2008-03-30 21:10:18] INFO  ruby 1.8.6 (2007-06-07) [i486-linux]
Server URL:
  http://localhost:8080/ACCOUNT/PROJECT/
  https://localhost:8081/ACCOUNT/PROJECT/
Server URL for HTTPS Unfuddle accounts:
  http://localhost:8080/ACCOUNT/PROJECT/
  https://localhost:8081/secure/ACCOUNT/PROJECT/
Test using irb:
  require 'xmlrpc/client'
  proxy = XMLRPC::Client.new2('http://USER:PASS@localhost:8080/ACCOUNT/PROJECT/')
  proxy.call('ticket.query', 'status!=closed')
  proxy.call('ticket.get', 1)
[2008-03-30 21:10:23] INFO  WEBrick::HTTPServer#start: pid=10608 port=8080

To test the server, open IRB and do what the server says upon startup:

  require 'xmlrpc/client'
  proxy = XMLRPC::Client.new2('http://USER:PASS@localhost:8080/ACCOUNT/PROJECT/')
  proxy.call('ticket.query', 'status!=closed')
  proxy.call('ticket.get', 1)

If your Unfuddle account supports/mandates secure connection, prepend "/secure" to the URL.
NOTE: Your connection to the XML-RPC server is still unencrypted unless you use the https form
for the XML-RPC connection itself.

Mylyn Support
-------------
The goal is to add seamless Mylyn support to Unfuddle projects.

This project will be archived when/if Subventure officially supports Trac XMLRPC syntax.

Project Info
------------
Project page: http://www.assembla.com/spaces/xmlrpcbridge
Maintainer: Hendy Irawan <hendy@rainbowpurple.com>
License: LGPLv3
