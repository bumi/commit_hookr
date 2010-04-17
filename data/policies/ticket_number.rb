CommitHookr.policy :ticket_number, :match => /\[\w+:.+\]/ do

  number = ui.ask("Ticket number: ")
  state  = ui.ask("Ticket state: ")
  
  state = "touch" if state == ""
  
  "[#{state}:#{number}]" if number != ""
end