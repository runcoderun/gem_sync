lib_path = File.expand_path(File.dirname(__FILE__) + "/../lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require 'rubygems'
gem "spicycode-micronaut"
gem "mocha"
require 'micronaut'
require 'mocha'
require 'rcr/gem_sync'

def not_in_editor?
  ['TM_MODE', 'EMACS', 'VIM'].all? { |k| !ENV.has_key?(k) }
end

def in_runcoderun?
  ENV["RUN_CODE_RUN"]
end

Micronaut.configure do |c|
  c.formatter = :documentation if in_runcoderun?
  c.alias_example_to :fit, :focused => true
  c.alias_example_to :xit, :disabled => true
  c.mock_with :mocha
  c.color_enabled = not_in_editor?
  c.filter_run :focused => true
end

