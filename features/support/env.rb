require "middleman"
root_path = File.dirname(File.dirname(File.dirname(__FILE__)))
require File.join(root_path, 'lib', 'middleman-i18n')
require "rack/test"