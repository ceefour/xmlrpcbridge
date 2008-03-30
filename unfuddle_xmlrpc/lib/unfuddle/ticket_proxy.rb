# LICENSE: LGPLv3

require 'rubygems'
require 'json'
require 'activesupport' # DateTime#to_time

module Unfuddle

  #  See:
  #  http://unfuddle.com/docs/api/tickets
  #  http://unfuddle.com/docs/api/data_models#ticket
  #
  #<ticket>
  #  <assignee-id type="integer"> </assignee-id>
  #  <component-id type="integer"> </component-id>
  #  <created-at type="datetime"> </created-at>
  #  <description> </description>
  #  <description-formatted> <!-- only available if formatted=true --> </description-formatted>
  #  <due-on type="date"> </due-on>
  #  <due-on-formatted> </due-on-formatted>
  #  <hours-estimate-current type="float"> </hours-estimate-current>
  #  <hours-estimate-initial type="float"> </hours-estimate-initial>
  #  <id type="integer"> </id>
  #  <milestone-id type="integer"> </milestone-id>
  #  <number type="integer"> </number>
  #  <priority> [1, 2, 3, 4, 5] </priority>
  #  <project-id type="integer"> </project-id>
  #  <reporter-id type="integer"> </reporter-id>
  #  <resolution> [fixed, works_for_me, postponed, duplicate, will_not_fix, invalid] </resolution>
  #  <resolution-description> </resolution-description>
  #  <resolution-description-formatted> <!-- only available if formatted=true --> </resolution-description-formatted>
  #  <severity-id type="integer"> </severity-id>
  #  <status> [new, unaccepted, reassigned, reopened, accepted, resolved, closed] </status>
  #  <summary> </summary>
  #  <updated-at type="datetime"> </updated-at>
  #  <version-id type="integer"> </version-id>
  #</ticket>
  class TicketProxy
    attr_reader :account
    attr_reader :project_id
    
    def initialize(account, project_id)
      @account = account
      @project_id = project_id
    end
    
    # qstr: query string
    # returns ticket xmlrpc-ids in array
    def query(qstr)
      # TODO: implement proper Trac query filtering, at least the most common ones
      results = account.get "/projects/#{project_id}/tickets"
      results.map { |ticket| ticket['number'] }
    end
    
    # Fetch a ticket. Returns [id, time_created, time_changed, attributes].
    # result format:
    # [8, 1206581261, 1206581261,
    #    {"severity"=>"normal", "component"=>"...", "cc"=>"", "status"=>"new",
    #     "resolution"=>"", "reporter"=>"...", "type"=>"defect", "priority"=>"normal",
    #     "version"=>"", "summary"=>"...",
    #     "description"=>"...", "owner"=>"...", "milestone"=>"", "keywords"=>""}]
    def get(id)
      ticket = account.get "/projects/#{project_id}/tickets/by_number/#{id}"
      # TODO: severity, get severity using Unfuddle's severity-id and return its name
      # TODO: component, get component using Unfuddle's component-id and return its name
      # TODO: 'merge' Unfuddle's status and resolution into XMLRPC status
      [ticket['number'], #  <number type="integer"> </number>
        AccountProxy.parse_timestamp(ticket['created_at']).to_time.to_i, #  <created-at type="datetime"> </created-at>
        AccountProxy.parse_timestamp(ticket['updated_at']).to_time.to_i, #  <updated-at type="datetime"> </updated-at>
        {'severity' => 'normal', #  <severity-id type="integer"> </severity-id>
         'component' => '', #  <component-id type="integer"> </component-id>
         'cc' => '',
         'status' => ticket['status'], #  <status> [new, unaccepted, reassigned, reopened, accepted, resolved, closed] </status>
         'resolution' => ticket['resolution'], #  <resolution> [fixed, works_for_me, postponed, duplicate, will_not_fix, invalid] </resolution>
         'reporter' => account.person.get(ticket['reporter_id'])['username'], #  <reporter-id type="integer"> </reporter-id>
         'type' => 'defect',   #  <severity-id type="integer"> </severity-id>
         'priority' => 'normal', #  <priority> [1, 2, 3, 4, 5] </priority>
         'version' => '',   #  <version-id type="integer"> </version-id>
         'summary' => ticket['summary'], #  <summary> </summary>
         'description' => ticket['description'], #  <description> </description>
         'owner' => account.person.get(ticket['assignee_id'])['username'], #  <assignee-id type="integer"> </assignee-id>
         'milestone' => '', #  <milestone-id type="integer"> </milestone-id>
         'keywords' => ''}]
    end
  end

end