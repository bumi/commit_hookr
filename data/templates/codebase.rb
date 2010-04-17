CommitHookr.config = {:project => "<%= @project %>"}

CommitHookr.message do |msg|
  #msg.clear
  #msg.what_and_why
  msg.new_line
  msg.ticket_number
  msg.time_entry
end


CommitHookr.policy :time_entry, :match => /\{t:.+\}/ do

  minutes = ui.ask("How much time have you spent in minutes: ")
  
  "{t:#{minutes}}" if minutes != ""
  
end

CommitHookr.policy :ticket_number, :match => /\[.+:.+\]/ do
  ticket_input = ui.ask("Codebase ticket number ([number], list [m]y tickets, list [a]ll tickets): ")
  
  case ticket_input 
  when "a"
    list_all_tickets
    ticket_number
  when "m"
    list_my_tickets
    ticket_number
  when /\d+/
    number,state = ticket_input.split(":")
    state ||= "touch"
    
    " [#{state}:#{number}]"
  end
end

CommitHookr.helpers do

  def list_all_tickets
    user = `git config codebase.username`.strip
    api_key = `git config codebase.apikey`.strip
    domain = `git config codebase.domain`.strip
  
    print_tickets CodebaseTickets.new( 
      :user    => user, 
      :api_key => api_key, 
      :domain  => domain, 
      :project => CommitHookr.config[:project]
    ).all("status:open sort:created order:asc")["tickets"]
  end

  def list_my_tickets
    user = `git config codebase.username`.strip
    api_key = `git config codebase.apikey`.strip
    domain = `git config codebase.domain`.strip
  
    print_tickets CodebaseTickets.new( 
      :user    => user, 
      :api_key => api_key, 
      :domain  => domain, 
      :project => CommitHookr.config[:project]
    ).all("assignee:#{user} status:open sort:created order:asc")["tickets"]
  end

  def print_tickets(tickets)
    tickets = [tickets].flatten
    tickets.delete(nil)
    puts "---"
    tickets.each do |ticket|
      puts "#{ticket["ticket_id"]}: #{ticket["summary"]}"
    end
    puts ""
  end
  
end


class CodebaseTickets
  require "httparty"
  include HTTParty
  headers 'Accept' => 'application/xml'
  headers 'Content-type' => 'application/xml'
  format :xml
  
  def initialize(args)
    @auth = {:username => args.delete(:user), :password => args.delete(:api_key)}
    @host = args.delete(:domain)
    @project = args.delete(:project)
  end
  
  def all(query="")
    self.class.get("http://#{@host}/#{@project}/tickets", :basic_auth => @auth, :query => {:query => query})
  end
end
