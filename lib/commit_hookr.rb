#!/usr/bin/env ruby
require "rubygems"
require "highline"
require "commit_hookr/message"

HighLine.track_eof = false

module CommitHookr
  
  @@message_script = proc {}
  @@policies = {}
  @@helper_script = proc {}
  @@config = {}
  def self.message_script
    @@message_script
  end
  def self.policies
    @@policies
  end
  def self.helper_script
    @@helper_script
  end
  def self.config
    @@config
  end
  def self.config=(value)
    @@config = value
  end
  
  def self.message(&block)
    @@message_script = block
  end
  
  def self.policy(name, options={}, &block)
    @@policies[name] = options.merge(:command => block)
  end
  
  def self.helpers(&block)
    @@helper_script = block
  end
  
  def self.call(&block)
    puts "your .hookr file is deprecated and ignored. Please run hookr -t <your template> to update your .hookr file and the git commit-msg hook. For more information check the readme on http://github.com/skddc/commit_hookr"
    exit
  end
  def self.new(*args)
    exit
  end
  
end
Dir[File.join(File.dirname(__FILE__), "../data/", "policies", "*.rb")].each do |policy|
  require policy
end