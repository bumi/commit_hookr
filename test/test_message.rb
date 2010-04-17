require 'helper'

class TestCommitHookrMessage < Test::Unit::TestCase
  
  def test_load_helpers
    CommitHookr.helpers do
      def my_helper
        "bar"
      end
    end
    message = hookr_message
    assert message.respond_to?("my_helper")
    assert "bar", message.my_helper
  end
  
  def test_load_original_content
    message = hookr_message
    assert_equal original_message, message.content
  end
  
  def test_clear_content
    message = hookr_message
    message.clear
    assert_equal "", message.content
  end
  
  def test_append_message
    message = hookr_message
    message.append(" heyho")
    assert_equal "#{original_message} heyho ", message.content 
  end
  def test_prepend_message
    message = hookr_message
    message.prepend("heyho")
    assert_equal "heyho #{original_message}", message.content 
  end
  
  def test_new_line
    message = hookr_message
    message.new_line
    message.append("heyho") 
    assert_equal "#{original_message}\nheyho ", message.content
  end
  
  def test_abort
    message = hookr_message
    message.expects(:exit).with(1)
    message.abort!
  end
  def test_commit
    message = hookr_message
    message.expects(:exit).with(0)
    message.commit!
  end
  
  def test_executing_policies
    
  end
  
  def hookr_message
    CommitHookr::Message.new(COMMIT_MESSAGE_FILE)
  end
  def original_message
    File.read(COMMIT_MESSAGE_FILE)
  end
end