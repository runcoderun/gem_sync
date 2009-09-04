require 'optparse'

module Rcr
  class OptionParsing

    def self.parse(args)
      options = {}
    
      OptionParser.new do |opts|
        opts.banner = "Usage: gem_sync [options]"

        opts.on('-p', '--platform [PLATFORM]', 'Specify an optional platform') do |o|
          options[:platform] = o.strip
        end

        opts.on('-g', '--github', 'Pull the list of gems to install from github') do |o|
          options[:github] = o
          options[:gem_list] = Rcr::GemSync::RCR_GITHUB_GEM_LIST
        end
        
        opts.on('-v', '--version', 'Run in verbose mode') do |o|
          options[:verbose] = o
        end
        
        opts.on('-n', '--dry-run', 'Do a dry run without executing actions') do |o|
          options[:dry_run] = o
        end
        
      end.parse!(args)

      options
    end
  
  end
end