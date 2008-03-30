require 'rubygems'
require 'json'
require 'mechanize' # AccountProxy.agent
require 'date' # Unfuddle::Account.parse_timestamp
require 'activesupport' # DateTime#to_time

require 'unfuddle/person_proxy'
require 'unfuddle/project_proxy'

module Unfuddle

  class AccountProxy
    attr_accessor :account, :username, :password, :secure, :person
    
    def initialize(account, username, password, secure = false)
      @account = account
      @username = username
      @password = password
      @secure = secure
      @person = PersonProxy.new(self)
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
      "#{protocol}://#{CGI.escape(@account)}.unfuddle.com/api/v1"
    end
    
    def project(id)
      ProjectProxy.new(self, id)
    end
    
    def projects
      page = agent.get "#{api_url}/projects.json"
      json = JSON.parse(page.body)
    end
 
  end    

end