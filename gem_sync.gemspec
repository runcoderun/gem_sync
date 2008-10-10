Gem::Specification.new do |s|
  s.name = %q{gem_sync}
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new("= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rob Sanheim @ Relevance"]
  s.date = %q{2008-10-05}
  s.default_executable = %q{gem_sync}
  s.description = %q{Tool to install dependencies for RunCodeRun, though it could be used to bootstrap your own machines as well.}
  s.email = %q{rob@runcoderun.com}
  s.executables = ["gem_sync"]
  s.extra_rdoc_files = ["bin/gem_sync", "lib/rcr/gem_sync.rb", "lib/runcoderun_gems.txt", "README.txt"]
  s.files = ["bin/gem_sync", "gem_sync.gemspec", "History.txt", "lib/rcr/gem_sync.rb", "lib/runcoderun_gems.txt", "Manifest", "Manifest.txt", "Rakefile", "README.txt", "spec/gem_sync_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://runcoderun.com}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Gem_sync", "--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{gem_sync}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Tool to install dependencies for RunCodeRun, though it could be used to bootstrap your own machines as well.}
  s.test_files = ["spec/gem_sync_spec.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end
