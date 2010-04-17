require 'rubygems'
require 'test/unit'
require 'mocha'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'commit_hookr'

COMMIT_MESSAGE_FILE = File.join(File.dirname(__FILE__),"commit_message")

class Test::Unit::TestCase
end
