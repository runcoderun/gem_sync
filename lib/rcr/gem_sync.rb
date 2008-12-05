require 'ostruct'
require 'open-uri'

module Rcr
  class GemSync
    VERSION = '0.5.3.1'
    GITHUB = "http://gems.github.com"
    RCR_DEFAULT_GEM_LIST = File.expand_path(File.join(File.dirname(__FILE__), *%w[.. runcoderun_gems.txt]))
    RCR_GITHUB_GEM_LIST =      "http://github.com/runcoderun/gem_sync/raw/master/lib/runcoderun_gems.txt"
    RCR_GITHUB_GEM_BLACKLIST = "http://github.com/runcoderun/gem_sync/raw/master/lib/gem_blacklist.txt"

    def self.install_gems(gem_list = nil)
      gem_list = RCR_DEFAULT_GEM_LIST unless gem_list
      puts "gem_list: #{gem_list.inspect}"
      update_self
      read_gem_list(gem_list)
      install_gems_from_list
      update_gems
      uninstall_bad_gems(gem_list)
    end
    
    def self.uninstall_bad_gems(gem_list)
      return unless gem_list == "__from_github__"
      convert_gem_list(RCR_GITHUB_GEM_BLACKLIST).each do |rubygem|
        cmd = "gem uninstall -a -x #{rubygem.name}"
        puts cmd
        `#{cmd}`
      end
    end
    
    def self.fail_if_gem_list_doesnt_exist(gem_list)
      raise("gem_list should not be nil") unless gem_list
      unless gem_list[0..3] == "http"
        raise("file for gem_list #{gem_list} not found!") unless File.exists?(gem_list) 
      end
    end
    
    def self.update_self
      puts `gem update runcoderun-gem_sync --source #{GITHUB}`
    end
    
    def self.read_gem_list(gem_list)
      list = gem_list == "__from_github__" ? RCR_GITHUB_GEM_LIST : gem_list
      fail_if_gem_list_doesnt_exist(list)
      puts "Running gem_sync with list: #{list}."
      @@gem_list = open(list).read
    end
    
    def self.update_gems
      puts "Updating all gems to latest..."
      puts `gem update`
    end
    
    def self.install_gems_from_list
      convert_gem_list(@@gem_list).each do |rubygem|
        if gem_installed?(rubygem.name, rubygem.version)
          puts "skipping #{rubygem.name} #{rubygem.version} - already installed..."
          next
        end
        cmd = "gem install #{rubygem.name} --no-ri --no-rdoc"
        cmd << " --version #{rubygem.version}" if rubygem.version
        puts cmd
        puts `#{cmd}`
        unless $?.success?
          cmd << " --source #{GITHUB}"
          puts "***** WARNING Trying to install gem #{rubygem.name} from github - watch for security issues."
          puts cmd
          puts `#{cmd}`
        end
      end
    end
  
    def self.convert_gem_list(string)
      gems = []
      string.each do |line|
        name = parse_name(line)
        next unless name
        versions = parse_versions(line)
        if versions.empty?
          gems << OpenStruct.new(:name => name)
        else 
          versions.each do |version|
            gems << OpenStruct.new(:name => name, :version => version.strip)
          end
        end
      end
      gems
    end
    
    def self.parse_name(string)
      string.match(/[\w\-_]*/)[0]
    end
    
    def self.parse_versions(string)
      output = string.scan(/\((.*?)\)/).flatten
      output = output.map {|s| s.split(",") }.flatten
      output = output.map {|s| s.strip}
      output
    end
  
    def self.gem_installed?(name, version)
      installed_gems.detect {|gem| gem.name == name && gem.version == version}
    end
  
    def self.installed_gems
      @installed_gems ||= convert_gem_list `gem list`
    end
  
  end
end