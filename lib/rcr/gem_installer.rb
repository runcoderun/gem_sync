require 'ostruct'

module Rcr
  class GemInstaller
    VERSION = '0.1.4'
    GITHUB = "http://gems.github.com"
    RCR_GEM_LIST = File.expand_path(File.join(File.dirname(__FILE__), *%w[.. runcoderun_gems.txt]))
    GEM_LIST = ENV["GEM_LIST"] || ARGV[0] || RCR_GEM_LIST
  
    def self.install_gems
      gem_list = File.read(GEM_LIST)
      convert_gem_list(gem_list).each do |gem|
        if gem_installed?(gem.name, gem.version)
          puts "skipping #{gem.name} #{gem.version}"
          next
        end
        cmd = "gem install #{gem.name} --no-ri --no-rdoc"
        cmd << " --version #{gem.version}" if gem.version
        puts cmd
        puts `#{cmd}`
        unless $?.success?
          cmd << " --source #{GITHUB}"
          puts "***** WARNING Trying to install gem #{gem.name} from github - watch for security issues."
          puts cmd
          puts `#{cmd}`
        end
      end
    end
  
    def self.convert_gem_list(string)
      gems = []
      string.each do |line|
        result = line.match(/([\w\-_]*) \((.*)\)/)
        next unless result && result[1]
        versions = result[2] ? result[2].split(",") : ""
        versions.each do |version|
          gems << OpenStruct.new(:name => result[1], :version => version.strip)
        end
      end
      gems
    end
  
    def self.gem_installed?(name, version)
      installed_gems.detect {|gem| gem.name == name && gem.version == version}
    end
  
    def self.installed_gems
      @installed_gems ||= convert_gem_list `gem list`
    end
  
  end
end