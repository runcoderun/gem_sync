require 'open-uri'
require 'rcr/option_parsing'
require 'rcr/gem_parser'

module Rcr
  class GemSync
    GITHUB = "http://gems.github.com"
    RCR_DEFAULT_GEM_LIST = File.expand_path(File.join(File.dirname(__FILE__), *%w[.. runcoderun_gems.txt]))
    RCR_GITHUB_GEM_LIST =      "http://github.com/runcoderun/gem_sync/raw/master/lib/runcoderun_gems.txt"
    RCR_GITHUB_GEM_BLACKLIST = "http://github.com/runcoderun/gem_sync/raw/master/lib/gem_blacklist.txt"

    attr_accessor :gem_list
    def initialize(args = ["--github"])
      options = Rcr::OptionParsing.parse(args)
      @platform = options[:platform]
      @verbose = options[:verbose]
      @dry_run = options[:dry_run]
      @gem_list = options[:gem_list]
    end
    
    def verbose?
      @verbose
    end
    
    def dry_run?
      @dry_run
    end
    
    def read_gem_list
      open(gem_list).read
    end
    
    def platform_matches?(gem)
      if gem.platforms && @platform
        gem.platforms.include?(@platform)
      else
        true
      end
    end
    
    def sync
      @gem_list = read_gem_list
      @gems = parse_gems
      install_gems
    end
    
    def parse_gems
      @gems = Rcr::GemParser.convert_gem_list(@gem_list)
    end
    
    def install_gems
      @gems.each do |rubygem|
        next unless platform_matches?(rubygem)
        next if installed?(rubygem)
        install!(rubygem)
      end
    end
    
    def installed?(name, version)
      installed_gems.detect {|gem| gem.name == name && gem.version == version}
    end
    
    def installed_gems
      @installed_gems ||= Rcr::GemParser.convert_gem_list(`gem list`)
    end
    
    def install!(rubygem)
      install_from_rubyforge(rubygem) || install_from_github(rubygem)
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
