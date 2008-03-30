Unfuddle XML-RPC adapter
========================

This library provides Trac XML-RPC adapter for Unfuddle projects.

Starting the server:

./server.rb ACCOUNT USERNAME PASSWORD PROJECT

Example:

ACCOUNT=abc
USERNAME=jsmith
PASSWORD=chicken
PROJECT=superboo
./server.rb $ACCOUNT $USERNAME $PASSWORD $PROJECT

This will start the server on port 8080 (Ctrl+C to shutdown).
To change the port, set and export the environment variable XMLRPCSERVER_PORT.

[2008-03-30 19:05:47] INFO  WEBrick 1.3.1
[2008-03-30 19:05:47] INFO  ruby 1.8.6 (2007-06-07) [i486-linux]
Server URL: http://localhost:8080/
Test using irb:
  require 'xmlrpc/client'
  proxy = XMLRPC::Client.new2('http://localhost:8080/')
  proxy.call('ticket.query', 'status!=closed')
  proxy.call('ticket.get', 1)
[2008-03-30 19:05:48] INFO  WEBrick::HTTPServer#start: pid=9868 port=8080
localhost - - [30/Mar/2008:19:05:53 WIT] "POST / HTTP/1.1" 200 5780
- -> /
localhost - - [30/Mar/2008:19:05:58 WIT] "POST / HTTP/1.1" 200 2894
- -> /

To test the server, open IRB and do what the server says upon startup:

  require 'xmlrpc/client'
  proxy = XMLRPC::Client.new2('http://localhost:8080/')
  proxy.call('ticket.query', 'status!=closed')
  proxy.call('ticket.get', 1)

Mylyn Support
-------------
The goal is to add seamless Mylyn support to Unfuddle projects.

This project will be archived when/if Subventure officially supports Trac XMLRPC syntax.

Project Info
------------
Project page: http://www.assembla.com/spaces/xmlrpcbridge
Maintainer: Hendy Irawan <hendy@rainbowpurple.com>
License: LGPLv3
