require 'rubygems'
require 'rake'
require 'micronaut/rake_task'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "gem_sync"
    gem.summary = %Q{gem_sync}
    gem.description = %Q{Tool to install rubygems for RunCodeRun, though it could be used to bootstrap your own machines as well.}
    gem.email = "rob@runcoderun.com"
    gem.homepage = "http://github.com/runcoderun/gem_sync"
    gem.authors = ["Rob Sanheim"]
    gem.add_development_dependency "spicycode-micronaut"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
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

task :default => [:check_dependencies, :examples]