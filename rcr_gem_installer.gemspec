Gem::Specification.new do |s|
  s.name = %q{rcr_gem_installer}
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new("= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rob Sanheim @ Relevance"]
  s.date = %q{2008-09-10}
  s.default_executable = %q{rcr_gem_installer}
  s.description = %q{Tool to install dependancies for RunCodeRun, though it coudl be used to bootstrap your own machines as well.}
  s.email = %q{rob@runcoderun.com}
  s.executables = ["rcr_gem_installer"]
  s.extra_rdoc_files = ["bin/rcr_gem_installer", "lib/rcr/gem_installer.rb", "lib/runcoderun_gems.txt", "README.txt"]
  s.files = ["bin/rcr_gem_installer", "History.txt", "lib/rcr/gem_installer.rb", "lib/runcoderun_gems.txt", "Manifest", "Manifest.txt", "Rakefile", "README.txt", "spec/gem_installer_spec.rb", "rcr_gem_installer.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://runcoderun.com}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Rcr_gem_installer", "--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rcr_gem_installer}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Tool to install dependancies for RunCodeRun, though it coudl be used to bootstrap your own machines as well.}
  s.test_files = ["spec/gem_installer_spec.rb"]

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
