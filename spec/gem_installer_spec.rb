require 'test/spec'

require File.join(File.dirname(__FILE__), *%w[.. lib rcr gem_installer])

describe 'GemInstaller' do
  
  it "parses single version" do
    versions = Rcr::GemInstaller.parse_versions("foo (1.0.10)")
    versions[0].should == "1.0.10"
  end
  
  it "parses single digit version" do
    versions = Rcr::GemInstaller.parse_versions("echoe (3)")
    versions[0].should == "3"
  end

  it "parses four digit versions" do
    versions = Rcr::GemInstaller.parse_versions("fiveruns-memcache-client (1.5.0.3)")
    versions[0].should == "1.5.0.3"
  end
  
  it "parses with multiple versions" do
    versions = Rcr::GemInstaller.parse_versions("foo (1.0.10, 1.0.11)")
    versions[0].should == "1.0.10"
    versions[1].should == "1.0.11"
  end
  
  describe "parsing gem names" do
    
    it "parses gem name without versions" do
      Rcr::GemInstaller.parse_name("factory-girl").should == "factory-girl"
    end
    
    it "parses simple gem name" do
      Rcr::GemInstaller.parse_name("daemons (1.0.10)").should == "daemons"
    end

    it "parses name with dashes" do
      Rcr::GemInstaller.parse_name("diff-lcs (1.0.10)").should == "diff-lcs"
    end

    it "parses name with underscores" do
      Rcr::GemInstaller.parse_name("spec_converter_foo (1.0.10)").should == "spec_converter_foo"
    end
  end
  
end