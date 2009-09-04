require 'optparse'

module Rcr
  class OptionParsing

    def self.parse(args)
      options = {}
    
      OptionParser.new do |opts|
        opts.banner = "Usage: gem_sync [options]"

        opts.on('-p', '--platform [PLATFORM]', 'Specify an optional platform') do |o|
          options[:platform] = o
        end

        opts.on('-g', '--github', 'Pull the list of gems to install from github') do |o|
          options[:github] = o
          options[:gem_list] = Rcr::GemSync::RCR_GITHUB_GEM_LIST
        end
      end.parse!(args)

      options
    end
  
  end
end