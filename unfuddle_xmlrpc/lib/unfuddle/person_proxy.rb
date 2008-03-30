# LICENSE: LGPLv3

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
      account.get "/people/#{id}"
    end
    
  end
end