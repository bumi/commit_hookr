CommitHookr.policy :what_and_why do

  what = ui.ask("What did you do? ")
  why = ui.ask("Why? ")
  
  "#{what} #{why}" if what != "" || why != ""
  
end