#!/usr/bin/env ruby

if File.exist?(".hookr")
  require "rubygems"
  require "commit_hookr"
  load    ".hookr"
 
  CommitHookr::Message.new(ARGV[0]).generate
end