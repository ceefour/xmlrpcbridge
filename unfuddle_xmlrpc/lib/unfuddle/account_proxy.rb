# LICENSE: LGPLv3

require 'rubygems'
require 'json'
require 'mechanize' # AccountProxy.agent
require 'date' # Unfuddle::Account.parse_timestamp
require 'activesupport' # DateTime#to_time

require 'unfuddle/person_proxy'
require 'unfuddle/project_proxy'

module Unfuddle

  class AccountProxy
    attr_accessor :account_name, :username, :password, :secure, :person, :project
    
    def initialize(account_name, username, password, secure = false)
      @account_name = account_name
      @username = username
      @password = password
      @secure = secure
      @person = PersonProxy.new(self)
      @project = ProjectProxy.new(self)
    end
    
    # Parses Unfuddle's timestamp
    # TODO: handle timezone
    def self.parse_timestamp(timestamp_str)
      DateTime.strptime(timestamp_str, '%Y/%m/%d %H:%M:%S %z')
    end
    
    def agent
      agent = WWW::Mechanize.new
      agent.basic_auth username, password
      agent
    end
    
    def api_url
      protocol = @secure ? 'https' : 'http'
      "#{protocol}://#{CGI.escape(@account_name)}.unfuddle.com/api/v1"
    end
    
    # Returns the Ticket proxy for a specified project ID
    def ticket(project_id)
      TicketProxy.new(self, project_id)
    end
    
    def get(uri)
      puts 'Get ' + uri
      page = agent.get "#{api_url}#{uri}.json"
      JSON.parse(page.body)
    end
 
  end    
end