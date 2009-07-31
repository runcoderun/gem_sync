require 'rubygems'
require 'echoe'
require './lib/rcr/gem_sync.rb'
gem "spicycode-micronaut"
require 'micronaut'
require 'micronaut/rake_task'

Echoe.new('gem_sync', Rcr::GemSync::VERSION) do |p|
  p.rubyforge_name = 'gem_sync'
  p.email = 'rob@runcoderun.com'
  p.author = ["Rob Sanheim @ Relevance"]
  p.summary = "Tool to install dependencies for RunCodeRun, though it could be used to bootstrap your own machines as well."
  p.url = "http://runcoderun.com"
  p.test_pattern = 'spec/**/*_spec.rb'
  p.gemspec_format = :ruby
end

Micronaut::RakeTask.new(:examples)
namespace :examples do  
  
  desc "Run all micronaut examples using rcov"
  Micronaut::RakeTask.new :coverage do |t|
    t.pattern = "examples/**/*_example.rb"
    t.rcov = true
    t.rcov_opts = %[--exclude "gems/*,/Library/Ruby/*,config/*" --text-summary  --sort coverage]
  end
  
end

desc 'Load the library in an IRB session'
task :console do
  sh %(irb -r lib/rcr/gem_sync.rb)
end
