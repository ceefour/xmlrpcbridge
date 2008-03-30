require 'rubygems'
require 'json'
require 'cgi'

require 'unfuddle/ticket_proxy'

module Unfuddle
  class ProjectProxy
    attr_reader :account
    
    def initialize(account)
      @account = account
    end

    # Returns a project by ID
    def get(id)
      account.get "/projects/#{id.to_i}"
    end
    
    # Returns a project by short name
    def get_by_short_name(short_name)
      account.get "/projects/by_short_name/#{CGI.escape(short_name)}"
    end

    # List all projects
    def list
      account.get "/projects"
    end

  end
end