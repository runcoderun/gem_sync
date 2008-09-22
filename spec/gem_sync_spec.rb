require 'test/spec'

require File.join(File.dirname(__FILE__), *%w[.. lib rcr gem_sync])

describe 'GemSync' do

  describe "parsing a gem list" do
    it "parses gem list" do
      list = %[wirble (0.1.2)
xml-simple (1.0.11)
ZenTest (3.10.0, 3.9.2, 3.9.1, 3.8.0, 3.6.0)]
      gems = Rcr::GemSync.convert_gem_list(list)
      gems[0].name.should == "wirble"
      gems[0].version.should == "0.1.2"
      gems[1].name.should == "xml-simple"
      gems[1].version.should == "1.0.11"
      gems[2..-1].each { |gem| gem.name.should == "ZenTest"}
      gems[2].version.should == "3.10.0"
      gems[3].version.should == "3.9.2"
    end
  end
  
  describe "parsing versions" do
    it "parses single version" do
      versions = Rcr::GemSync.parse_versions("foo (1.0.10)")
      versions[0].should == "1.0.10"
    end

    it "parses single digit version" do
      versions = Rcr::GemSync.parse_versions("echoe (3)")
      versions[0].should == "3"
    end

    it "parses four digit versions" do
      versions = Rcr::GemSync.parse_versions("fiveruns-memcache-client (1.5.0.3)")
      versions[0].should == "1.5.0.3"
    end

    it "parses with multiple versions" do
      versions = Rcr::GemSync.parse_versions("foo (1.0.10, 1.0.11)")
      versions[0].should == "1.0.10"
      versions[1].should == "1.0.11"
    end
  end
  
  describe "parsing gem names" do
    
    it "parses gem name without versions" do
      Rcr::GemSync.parse_name("factory-girl").should == "factory-girl"
    end
    
    it "parses simple gem name" do
      Rcr::GemSync.parse_name("daemons (1.0.10)").should == "daemons"
    end

    it "parses name with dashes" do
      Rcr::GemSync.parse_name("diff-lcs (1.0.10)").should == "diff-lcs"
    end

    it "parses name with underscores" do
      Rcr::GemSync.parse_name("spec_converter_foo (1.0.10)").should == "spec_converter_foo"
    end
  end
  
end