require 'examples/example_helper'

describe Rcr::GemSync do

  def fake_gem(name, version)
    OpenStruct.new(:name => name, :version => version)
  end
  
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
  
  describe "installed?" do
    describe "is rspec installed?" do
      it "should be installed if any version of rspec is installed" do
        gem_sync = Rcr::GemSync.new
        gem_sync.stubs(:installed_gems).returns([fake_gem('rspec', '1.2.0')])
        gem_sync.installed?(OpenStruct.new(:name => "rspec")).should be_true
      end
      
      it "should not be installed if rspec is not installed" do
        gem_sync = Rcr::GemSync.new
        gem_sync.stubs(:installed_gems).returns([fake_gem('shoulda', '1.2.0')])
        gem_sync.installed?(OpenStruct.new(:name => "rspec")).should be_false
        gem_sync.installed?(OpenStruct.new(:name => "rspec", :version => '1.2.0')).should be_false
      end
    end
    
    describe "is rspec v1.2.3 installed?" do
      it "should be installed if rspec v1.2.3 is installed" do
        gem_sync = Rcr::GemSync.new
        gem_sync.stubs(:installed_gems).returns([fake_gem('rspec', '1.2.3'), fake_gem('rspec', '1.3.0')])    
        gem_sync.installed?(fake_gem('rspec', '1.2.3')).should be_true
      end
      
      it "should not be installed if rspec is installed, but v1.2.3 is not" do
        gem_sync = Rcr::GemSync.new
        gem_sync.stubs(:installed_gems).returns([fake_gem('rspec', '1.2.6'), fake_gem('rspec', '1.3.0')])    
        gem_sync.installed?(fake_gem('rspec', '1.2.3')).should be_false
      end
    end
  end
  
  describe "install_from_github" do
    it "should not attempt to install if there are no dashes in the name" do
      gem = fake_gem("somegem", '1.0.0')
      gem_sync = Rcr::GemSync.new
      gem_sync.expects(:run).never
      gem_sync.install_from_github(gem)
    end
    
    it "should attempt to install if there are dashes in the name" do
      gem = fake_gem("user-gem", '1.0.0')
      gem_sync = Rcr::GemSync.new
      gem_sync.expects(:run).never
      gem_sync.install_from_github(gem)
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
