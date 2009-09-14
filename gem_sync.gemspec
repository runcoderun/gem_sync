# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gem_sync}
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rob Sanheim"]
  s.date = %q{2009-09-13}
  s.default_executable = %q{gem_sync}
  s.description = %q{Tool to install rubygems for RunCodeRun, though it could be used to bootstrap your own machines as well.}
  s.email = %q{rob@runcoderun.com}
  s.executables = ["gem_sync"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.txt"
  ]
  s.files = [
    ".gitignore",
     "History.txt",
     "LICENSE",
     "Manifest",
     "Manifest.txt",
     "README.txt",
     "Rakefile",
     "VERSION",
     "bin/gem_sync",
     "examples/example_helper.rb",
     "examples/rcr/gem_parser_example.rb",
     "examples/rcr/gem_sync_example.rb",
     "examples/rcr/option_parsing_example.rb",
     "gem_sync.gemspec",
     "lib/rcr/gem_parser.rb",
     "lib/rcr/gem_sync.rb",
     "lib/rcr/option_parsing.rb",
     "lib/runcoderun_gems.txt"
  ]
  s.homepage = %q{http://github.com/runcoderun/gem_sync}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{gem_sync}
  s.test_files = [
    "examples/example_helper.rb",
     "examples/rcr/gem_parser_example.rb",
     "examples/rcr/gem_sync_example.rb",
     "examples/rcr/option_parsing_example.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<micronaut>, [">= 0"])
    else
      s.add_dependency(%q<micronaut>, [">= 0"])
    end
  else
    s.add_dependency(%q<micronaut>, [">= 0"])
  end
end
