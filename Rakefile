require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "gem_sync"
    gem.summary = %Q{gem_sync}
    gem.description = %Q{Tool to install rubygems for RunCodeRun, though it could be used to bootstrap your own machines as well.}
    gem.email = "rob@runcoderun.com"
    gem.homepage = "http://github.com/runcoderun/gem_sync"
    gem.authors = ["Rob Sanheim"]
    gem.add_development_dependency "micronaut"
    gem.files.exclude(".gitignore")
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

begin
  require 'micronaut/rake_task'
  Micronaut::RakeTask.new(:examples) do |t|
    t.ruby_opts << '-Ilib -Iexamples'
  end
  namespace :examples do  
  
    desc "Run all micronaut examples using rcov"
    Micronaut::RakeTask.new :coverage do |t|
      t.pattern = "examples/**/*_example.rb"
      t.rcov = true
      t.rcov_opts = %[--exclude "gems/*,/Library/Ruby/*,config/*" --text-summary  --sort coverage]
    end
  
  end
rescue LoadError
  puts "Micronaut required for test suite"
end

desc 'Load the library in an IRB session'
task :console do
  sh %(irb -r lib/rcr/gem_sync.rb)
end

if RUBY_VERSION =~ /1.9/
  task :default => :examples
else
  task :default => [:check_dependencies, :examples]
end