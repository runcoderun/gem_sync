
# Gem::Specification for Rcr_gem_sync-0.2.0
# Originally generated by Echoe

--- !ruby/object:Gem::Specification 
name: rcr_gem_sync
version: !ruby/object:Gem::Version 
  version: 0.2.0
platform: ruby
authors: 
- Rob Sanheim @ Relevance
autorequire: 
bindir: bin

date: 2008-09-20 00:00:00 -04:00
default_executable: 
dependencies: 
- !ruby/object:Gem::Dependency 
  name: echoe
  type: :development
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
    version: 
description: Tool to install dependancies for RunCodeRun, though it could be used to bootstrap your own machines as well.
email: rob@runcoderun.com
executables: 
- rcr_gem_sync
extensions: []

extra_rdoc_files: 
- bin/rcr_gem_sync
- lib/rcr/gem_sync.rb
- lib/runcoderun_gems.txt
- README.txt
files: 
- bin/rcr_gem_sync
- History.txt
- lib/rcr/gem_sync.rb
- lib/runcoderun_gems.txt
- Manifest
- Manifest.txt
- Rakefile
- README.txt
- spec/gem_sync_spec.rb
- rcr_gem_sync.gemspec
has_rdoc: true
homepage: http://runcoderun.com
post_install_message: 
rdoc_options: 
- --line-numbers
- --inline-source
- --title
- Rcr_gem_sync
- --main
- README.txt
require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
required_rubygems_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - "="
    - !ruby/object:Gem::Version 
      version: "1.2"
  version: 
requirements: []

rubyforge_project: rcr_gem_sync
rubygems_version: 1.2.0
specification_version: 2
summary: Tool to install dependancies for RunCodeRun, though it could be used to bootstrap your own machines as well.
test_files: 
- spec/gem_sync_spec.rb
