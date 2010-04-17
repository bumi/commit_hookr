CommitHookr.policy :time_entry, :match => /\{t:.+\}/ do

  minutes = ui.ask("How much time have you spent in minutes: ")
  
  "{t:#{minutes}}" if minutes != ""
  
end