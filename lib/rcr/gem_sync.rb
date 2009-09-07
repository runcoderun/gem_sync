require 'open-uri'
require 'rcr/option_parsing'
require 'rcr/gem_parser'

module Rcr
  class GemSync
    GITHUB = "http://gems.github.com"
    RCR_DEFAULT_GEM_LIST = File.expand_path(File.join(File.dirname(__FILE__), *%w[.. runcoderun_gems.txt]))
    RCR_GITHUB_GEM_LIST =      "http://github.com/runcoderun/gem_sync/raw/master/lib/runcoderun_gems.txt"
    RCR_GITHUB_GEM_BLACKLIST = "http://github.com/runcoderun/gem_sync/raw/master/lib/gem_blacklist.txt"

    def initialize(args = ["--github"])
      options = Rcr::OptionParsing.parse(args)
      @platform = options[:platform]
      @verbose = options[:verbose]
      @dry_run = options[:dry_run]
      @gem_list = options[:gem_list]
      system("gem env") if verbose?
    end
    
    def sync
      @gem_list = read_gem_list
      @gems = parse_gems
      install_gems
    end
    
    def verbose?
      @verbose
    end
    
    def dry_run?
      @dry_run
    end
    
    def read_gem_list
      open(@gem_list).read
    end
    
    def platform_matches?(gem)
      if gem.platforms && @platform
        gem.platforms.include?(@platform)
      else
        true
      end
    end
    
    def parse_gems
      @gems = Rcr::GemParser.convert_gem_list(@gem_list)
    end
    
    def install_gems
      @gems.each { |rubygem| install!(rubygem) }
    end

    def install!(rubygem)
      return unless platform_matches?(rubygem)
      return if installed?(rubygem)
      install_from_rubyforge(rubygem) || install_from_github(rubygem)
    end
    
    def gem_installed?(name)
      installed_gems.any? { |installed| installed.name == name }
    end
    
    def gem_version_installed?(version)
      return true if version.nil?
      installed_gems.any? { |installed| installed.version == version }
    end
    
    def installed?(requested)
      gem_installed?(requested.name) && gem_version_installed?(requested.version)
    end
    
    def installed_gems
      @installed_gems ||= Rcr::GemParser.convert_gem_list(`gem list`)
    end
    
    def install_from_rubyforge(rubygem)
      cmd = "gem install #{rubygem.name} --no-ri --no-rdoc"
      cmd << " --version #{rubygem.version}" if rubygem.version
      run(cmd)
    end
    
    def install_from_github(rubygem)
      cmd = "gem install #{rubygem.name} --no-ri --no-rdoc"
      cmd << " --version #{rubygem.version}" if rubygem.version
      cmd << " --source #{GITHUB}"
      run(cmd)
    end
    
    def run(cmd)
      if dry_run?
        puts cmd
        true
      else
        puts cmd if verbose?
        system(cmd)
      end
    end
    
  end
end
