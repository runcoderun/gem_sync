require 'test/spec'
require 'mocha'
require File.join(File.dirname(__FILE__), *%w[.. lib rcr gem_sync])

describe 'GemSync' do

  describe "calling gem_sync" do
  end
  
  describe "reading file" do
    before do
      Rcr::GemSync.stubs :update_self
      Rcr::GemSync.stubs :install_gems_from_list
      Rcr::GemSync.stubs :update_gems
    end

    it "uses default gem list for nil gem list" do
      Rcr::GemSync.expects(:open).with(Rcr::GemSync::RCR_DEFAULT_GEM_LIST).returns(StringIO.new)
      Rcr::GemSync.install_gems
      Rcr::GemSync.expects(:open).with(Rcr::GemSync::RCR_DEFAULT_GEM_LIST).returns(StringIO.new)
      Rcr::GemSync.install_gems nil
    end
      
    it "allows overriding gem list file" do
      Rcr::GemSync.stubs(:fail_if_gem_list_doesnt_exist).returns(true)
      Rcr::GemSync.expects(:open).with("/my/gems.txt").returns(StringIO.new)
      Rcr::GemSync.install_gems "/my/gems.txt"
    end
    
    it "reads file for gem list" do
      Rcr::GemSync.stubs(:fail_if_gem_list_doesnt_exist).returns(true)
      Rcr::GemSync.expects(:open).with("/my/gems.txt").returns(StringIO.new)
      Rcr::GemSync.read_gem_list "/my/gems.txt"
    end
    
    it "reads from gem list and blacklist on github if passed github param" do
      Rcr::GemSync.expects(:open).with(Rcr::GemSync::RCR_GITHUB_GEM_LIST).returns(StringIO.new)
      Rcr::GemSync.expects(:open).with(Rcr::GemSync::RCR_GITHUB_GEM_BLACKLIST).returns(StringIO.new)
      
      Rcr::GemSync.install_gems "__from_github__"
    end

  end
  
  describe "parsing a gem list" do
    it "parses gems without a version" do
            list = %[wirble]
            gems = Rcr::GemSync.convert_gem_list(list)
            gems[0].name.should == "wirble"
            gems[0].version.should == nil
    end
    
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
    
    it "can use version strings" do
      list = %[do_sqlite3 (<= 0.9.8)]
      gems = Rcr::GemSync.convert_gem_list(list)
      gems.first.version.should == '<= 0.9.8'
    end
  end
  
  describe "parsing versions" do
    it "parses without a version" do
      versions = Rcr::GemSync.parse_versions("foo")
      versions[0].should == nil
    end
    
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
    
    it "parses gems with numbers in the name" do
      Rcr::GemSync.parse_versions("open4 (0.9.6)")[0].should == "0.9.6"
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
  
  describe "failed installation" do
    xit "should skip the gem and move on if failed due to permission denied" do
      out = "Permission denied - /opt/local/lib/ruby/gems/1.8/cache/activesupport-1.4.4.gem"
    end
    
    xit "logs connection refused and skips gem, usually due to firewall blocking or gem mirrir is down"
    
    xit "should try to install from github if gem was not found in default source(s)" do
    end
  end
  
end