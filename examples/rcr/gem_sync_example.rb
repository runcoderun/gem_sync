require 'examples/example_helper'

describe Rcr::GemSync do

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

  
  describe "failed installation" do
    xit "should skip the gem and move on if failed due to permission denied" do
      out = "Permission denied - /opt/local/lib/ruby/gems/1.8/cache/activesupport-1.4.4.gem"
    end
    
    xit "logs connection refused and skips gem, usually due to firewall blocking or gem mirrir is down"
    
    xit "should try to install from github if gem was not found in default source(s)" do
    end
  end
  
end
