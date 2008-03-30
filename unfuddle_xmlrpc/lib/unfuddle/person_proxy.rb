require 'rubygems'
require 'json'

module Unfuddle
  # This is not available in Trac XMLRPC, but can be used nonetheless.
  class PersonProxy
    attr_reader :account
    
    def initialize(account)
      @account = account
    end
    
    def get(id)
      url = "#{account.api_url}/people/#{id}.json"
      JSON.parse(account.agent.get(url).body)
    end
    
  end
end