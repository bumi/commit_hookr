module CommitHookr
  
  class Message
    attr_accessor :content, :message_file
    
    def initialize(message_file)
      self.message_file = message_file
      self.content = File.read(message_file)
      self.instance_eval &CommitHookr.helper_script if CommitHookr.helper_script
    end
    
    def clear
      self.content = ""
    end
    def new_line
      self.content << "\n"
    end
    
    def prepend(message)
      self.content = "#{message} #{self.content}"
    end
    
    def append(message)
      self.content << "#{message} "
    end
    
    def ui
      @highline ||= HighLine.new
    end
    
    def generate
      STDIN.reopen '/dev/tty' unless STDIN.tty?
      instance_eval &CommitHookr.message_script
      write!
      commit!
    end
    
    def write!
      File.open(message_file, "w+") do |f|
        f.write self.content
      end
    end
    
    def abort!
      exit 1
    end
    def commit!
      exit 0
    end
    
    def method_missing(name,*args)
      if policy_options = CommitHookr.policies[name]
        return true if policy_options[:match] && self.content.match(policy_options[:match])
        append instance_eval(&policy_options[:command])
      else
        super(name,*args)
      end
    end
    
  end
  
end