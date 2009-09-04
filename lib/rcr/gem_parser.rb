require 'ostruct'

module Rcr
  class GemParser
    
    def self.convert_gem_list(string)
      gems = []
      string.each do |line|
        name = parse_name(line)
        next unless name
        versions = parse_versions(line)
        platforms = parse_platforms(line)
        if versions.empty?
          gems << OpenStruct.new(:name => name, :platforms => platforms)
        else 
          versions.each do |version|
            gems << OpenStruct.new(:name => name, :version => version.strip, :platforms => platforms)
          end
        end
      end
      gems
    end
    
    def self.parse_name(string)
      result = string.gsub(/#.*/, "").match(/[\w\-_]*/)[0]
      result != "" ? result : nil
    end
    
    def self.parse_versions(string)
      output = string.scan(/\((.*?)\)/).flatten
      output = output.map {|s| s.split(",") }.flatten
      output = output.map {|s| s.strip}
      output
    end
  
    def self.parse_platforms(string)
      string.scan(/\+[\w-]+\b/).map! { |platform| platform.gsub!('+', '') }
    end
    
    
  end
end