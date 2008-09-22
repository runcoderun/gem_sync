require 'ostruct'

module Rcr
  class GemSync
    VERSION = '0.2.5'
    GITHUB = "http://gems.github.com"
    RCR_GEM_LIST = File.expand_path(File.join(File.dirname(__FILE__), *%w[.. runcoderun_gems.txt]))
  
    def self.install_gems
      gem_list = File.read(RCR_GEM_LIST)
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
        name = parse_name(line)
        next unless name
        versions = parse_versions(line)
        versions.each do |version|
          gems << OpenStruct.new(:name => name, :version => version.strip)
        end
      end
      gems
    end
    
    def self.parse_name(string)
      string.match(/[\w\-_]*/)[0]
    end
    
    def self.parse_versions(string)
      string.scan(/([\d\.]+)/).flatten
    end
  
    def self.gem_installed?(name, version)
      installed_gems.detect {|gem| gem.name == name && gem.version == version}
    end
  
    def self.installed_gems
      @installed_gems ||= convert_gem_list `gem list`
    end
  
  end
end