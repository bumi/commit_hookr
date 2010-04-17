require 'helper'

class TestCommitHookr < Test::Unit::TestCase
  def test_config_hash
    assert_equal({}, CommitHookr.config)
    
    CommitHookr.config = {:foo=>"bar"}
    
    assert_equal({:foo => "bar"}, CommitHookr.config)
  end
end
