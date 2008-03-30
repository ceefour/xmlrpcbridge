require 'xmlrpc/server'

class UnfuddleServlet < XMLRPC::WEBrickServlet
  attr_accessor :secure
  
  def self.get_instance(server, *options)
    # always create a new servlet, it's ok
    servlet = UnfuddleServlet.new
    if options && options.first && !options.first.empty?
      hash = options[0]
      if hash[:secure]
        servlet.secure = true
      end
    end
    servlet
  end
  
  def service(request, response)
    # get the account name, project name, username, and password
    username = password = nil
    WEBrick::HTTPAuth.basic_auth request, response, 'Trac XML-RPC Adapter for Unfuddle' do |user, pass|
      username = user
      password = pass
    end
    dummy, account_name, project_short_name = request.path_info.match(/^\/([a-zA-Z0-9\_]+)\/([a-zA-Z0-9\_]+)/).to_a
    secure = @secure || false
    # add handlers
    puts "Loading account [#{account_name}] project [#{project_short_name}] secure [#{secure}]..."
    account = Unfuddle::AccountProxy.new(account_name, username, password, secure)
    project = account.project.get_by_short_name(project_short_name)
    ticket = account.ticket(project['id'])
    ticket_interface = XMLRPC::interface('ticket') {
      meth 'array query(string)', 'Query tickets and return ticket IDs'
      meth 'array get(id)', 'Get ticket detail'
    }
    add_handler ticket_interface, ticket
    super(request, response)
  end
  
end