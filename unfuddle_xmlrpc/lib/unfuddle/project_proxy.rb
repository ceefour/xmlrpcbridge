require 'rubygems'
require 'json'

require 'unfuddle/ticket_proxy'

module Unfuddle
  class ProjectProxy
    attr_reader :account
    attr_reader :id
    attr_reader :ticket
    
    def initialize(account, id)
      @account = account
      @id = id
      @ticket = TicketProxy.new(self)
    end
    
    def api_url
      "#{account.api_url}/projects/#{id}"
    end

  end
end