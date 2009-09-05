require 'examples/example_helper'

describe Rcr::GemSync do

  describe "sync" do
    it "should read gem list, install each gem, ..." do
      gem_sync = Rcr::GemSync.new(["--github"])
      gem_sync.expects(:read_gem_list)
      gem_sync.expects(:parse_gems)
      gem_sync.expects(:install_gems)
      gem_sync.sync
    end
  end
  
  describe "install_gems" do
    it "should iterate over each gem and install!" do
      gem_sync = Rcr::GemSync.new(["--github"])
      gem_sync.expects(:read_gem_list).returns(<<-EOL)
gem1 (1.0.0)
gem2 (1.0.0)      
EOL
      gem_sync.expects(:run).times(2).returns(true)
      gem_sync.sync
    end
    
    it "should install gems that have no platform, even when gem sync platform is specified" do
      gem_sync = Rcr::GemSync.new(["-p ruby191"])
      gem_sync.expects(:read_gem_list).returns(<<-EOL)
gem1 (1.0.0)
EOL
      gem_sync.expects(:run).once.returns(true)
      gem_sync.sync
    end
    
    it "shoud do nothing if the platform does not match" do
      gem_sync = Rcr::GemSync.new(["-p ruby191"])
      gem_sync.expects(:read_gem_list).returns(<<-EOL)
gem1 (1.0.0) +jruby130
EOL
      gem_sync.expects(:run).never
      gem_sync.sync
    end
  end
  
  describe "install!" do
    it "should skip if already installed" do
      gem = stub_everything("gem", :name => "foo")
      gem_sync = Rcr::GemSync.new
      gem_sync.expects(:installed?).with(gem).returns(true)
      gem_sync.expects(:run).never
      gem_sync.install!(gem)
    end
    
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

  describe "platform_matches?" do
    it "should return true if there is no platform" do
      Rcr::GemSync.new.platform_matches?(OpenStruct.new).should == true
    end
    
    it "should return true if gem sync platform is specified and gem has no platform" do
      gem_sync = Rcr::GemSync.new(["-p ruby191"])
      gem_sync.platform_matches?(OpenStruct.new).should == true
    end
    
    it "should return false gem sync and gem platform do not match" do
      gem_sync = Rcr::GemSync.new(["-p ruby191"])
      gem_sync.platform_matches?(OpenStruct.new(:platforms => ["jruby130"])).should == false
    end

    it "should return true if gem platform and current platform match" do
      gem_sync = Rcr::GemSync.new(["-p ruby191"])
      gem_sync.platform_matches?(OpenStruct.new(:platforms => ["ruby191"])).should == true
    end
    
    it "should return if gem platforms includes the current platform" do
      gem_sync = Rcr::GemSync.new(["-p ruby191"])
      gem_sync.platform_matches?(OpenStruct.new(:platforms => ["jruby130", "ruby191"])).should == true
    end
  end
  
  describe "read gem list" do
    it "should read the gem list" do
      gem_sync = Rcr::GemSync.new(["--github"])
      gem_sync.expects(:open).with(Rcr::GemSync::RCR_GITHUB_GEM_LIST).returns(StringIO.new)
      gem_sync.read_gem_list
    end
  end
  
end
