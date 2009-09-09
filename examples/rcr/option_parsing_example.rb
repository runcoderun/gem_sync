require 'examples/example_helper'

describe Rcr::OptionParsing do

  describe "gem list" do
    it "uses github list for -g" do
      opts = Rcr::OptionParsing.parse(["-g"])
      opts[:github].should be_true
    end

    it "defaults to non github" do
      opts = Rcr::OptionParsing.parse([])
      opts[:github].should be_nil
    end
    
    it "returns github source url if github list selected" do
      opts = Rcr::OptionParsing.parse(["-g"])
      opts[:gem_list].should == Rcr::GemSync::RCR_GITHUB_GEM_LIST
    end
  end
  
  describe "verbose" do
    it "can be extra verbose" do
      opts = Rcr::OptionParsing.parse(["--verbose-gem"])
      opts[:verbose_gem].should be_true
    end
    
    it "can be verbose" do
      opts = Rcr::OptionParsing.parse(["-v"])
      opts[:verbose].should be_true
    end
  end
  
end
