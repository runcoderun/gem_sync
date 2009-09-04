require 'examples/example_helper'

describe Rcr::GemSync do

  describe "creating a gem_sync" do
    
    it "requires a gem list" do
      lambda {
        Rcr::GemSync.new([])
      }.should raise_error(ArgumentError)
      end
      
      it "saves github gem list source" do
        Rcr::GemSync.new(["--github"]).gem_list.should == Rcr::GemSync::RCR_GITHUB_GEM_LIST
      end
    
  end
  
  describe "sync" do
    it "should read gem list, install each gem, ..." do
      gem_sync = Rcr::GemSync.new(["--github"])
      gem_sync.expects(:read_gem_list)
      gem_sync.expects(:install_gems)
      gem_sync.sync
    end
  end
  
  describe "install_gems" do
    it "should iterate over each gem, and install unless already installed" do
      gem_sync = Rcr::GemSync.new(["--github"])
      gem1 = stub_everything(:name => "gem1", :version => "1.0.0")
      gem2 = stub_everything(:name => "gem2", :version => "1.0.0")
      gem_sync.expects(:read_gem_list).returns([gem1, gem2])
      gem_sync.expects(:installed?).with("gem1", "1.0.0").returns(true)
      gem_sync.expects(:installed?).with("gem2", "1.0.0").returns(false)
      gem_sync.expects(:install!).with(gem1).never
      gem_sync.expects(:install!).with(gem2)
      gem_sync.sync
    end
  end
  
  describe "install!" do
    it "should try installing as rubyforge first" do
      gem = OpenStruct.new(:name => "foo", :version => "1.0.0")
      gem_sync = Rcr::GemSync.new
      gem_sync.expects(:run).with("gem install foo --no-ri --no-rdoc --version 1.0.0").returns(true)
      gem_sync.install!(gem)
    end
    
    it "should fall back to github if not found on rubyforge" do
      gem = OpenStruct.new(:name => "johndoe-foo", :version => "1.0.0")
      gem_sync = Rcr::GemSync.new
      gem_sync.expects(:run).with("gem install johndoe-foo --no-ri --no-rdoc --version 1.0.0").returns(false)
      gem_sync.expects(:run).with("gem install johndoe-foo --no-ri --no-rdoc --version 1.0.0 --source http://gems.github.com")
      gem_sync.install!(gem)
    end
    
  end
  
  describe "read gem list" do
    it "should read the gem list" do
      gem_sync = Rcr::GemSync.new(["--github"])
      gem_sync.expects(:open).with(Rcr::GemSync::RCR_GITHUB_GEM_LIST).returns(StringIO.new)
      gem_sync.read_gem_list
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
