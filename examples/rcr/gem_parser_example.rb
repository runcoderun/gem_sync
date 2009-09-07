require 'examples/example_helper'

describe Rcr::GemParser do

  describe "converting a gem list" do
    it "parses gems without a version" do
      list = %[wirble]
      gems = Rcr::GemParser.convert_gem_list(list)
      gems[0].name.should == "wirble"
      gems[0].version.should == nil
    end
    
    it "parses okay with commented lines" do
      list = %[# here is a comment
# and another

xml-simple (1.0.11)]
      gems = Rcr::GemParser.convert_gem_list(list)
      gems.size.should == 1
    end

    it "parses gem list" do
      list = %[wirble (0.1.2)
xml-simple (1.0.11)
ZenTest (3.10.0, 3.9.2, 3.9.1, 3.8.0, 3.6.0)]
        gems = Rcr::GemParser.convert_gem_list(list)
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
        gems = Rcr::GemParser.convert_gem_list(list)
        gems.first.version.should == '<= 0.9.8'
      end
      
      it "parses gem list" do
        list = %[wirble (0.1.2) +ruby_186 # here is a gem]
        gem = Rcr::GemParser.convert_gem_list(list).first
        gem.name.should == "wirble"
        gem.version.should == "0.1.2"
        gem.platforms.should == ["ruby_186"]
      end
    end

    describe "parsing platforms" do
      it "should return nil for no platforms" do
        list = %[rambow_likes_gerbils (<= 7.3.2)]
        gem = Rcr::GemParser.convert_gem_list(list).first
        gem.platforms.should be_nil
      end
      
      it "is parses a single platform" do
        list = %[rambow_likes_gerbils (<= 7.3.2) +ruby186]
        gem = Rcr::GemParser.convert_gem_list(list).first
        gem.platforms.should == %w{ruby186}
      end

      it "parses multiple platforms" do
        list = %[some-gem-foo (<= 7.3.2) +ruby186 +jruby130]
        gem = Rcr::GemParser.convert_gem_list(list).first
        gem.platforms.should == %w{ruby186 jruby130}
      end

      it "parses platforms with dashes and underscores" do
        list = %[rambow_likes_gerbils (1.0, 2.0) +ruby-186 +jruby_130]
        gem = Rcr::GemParser.convert_gem_list(list).first
        gem.platforms.should == %w{ruby-186 jruby_130}
      end
    end

    describe "parsing versions" do
      it "parses without a version" do
        versions = Rcr::GemParser.parse_versions("foo")
        versions[0].should == nil
      end

      it "parses single version" do
        versions = Rcr::GemParser.parse_versions("foo (1.0.10)")
        versions[0].should == "1.0.10"
      end

      it "parses single digit version" do
        versions = Rcr::GemParser.parse_versions("echoe (3)")
        versions[0].should == "3"
      end

      it "parses four digit versions" do
        versions = Rcr::GemParser.parse_versions("fiveruns-memcache-client (1.5.0.3)")
        versions[0].should == "1.5.0.3"
      end

      it "parses with multiple versions" do
        versions = Rcr::GemParser.parse_versions("foo (1.0.10, 1.0.11)")
        versions[0].should == "1.0.10"
        versions[1].should == "1.0.11"
      end

      it "parses gems with numbers in the name" do
        Rcr::GemParser.parse_versions("open4 (0.9.6)")[0].should == "0.9.6"
      end
    end

    describe "parsing gem names" do
      it "returns nil for comments" do
        Rcr::GemParser.parse_name("# I hate factory-girl").should be_nil
      end
      
      it "returns nil for empty lines" do
        Rcr::GemParser.parse_name("   ").should be_nil
      end
      
      it "parses gem name without versions" do
        Rcr::GemParser.parse_name("factory-girl").should == "factory-girl"
      end

      it "parses simple gem name" do
        Rcr::GemParser.parse_name("daemons (1.0.10)").should == "daemons"
      end

      it "parses name with dashes" do
        Rcr::GemParser.parse_name("diff-lcs (1.0.10)").should == "diff-lcs"
      end

      it "parses name with underscores" do
        Rcr::GemParser.parse_name("spec_converter_foo (1.0.10)").should == "spec_converter_foo"
      end
    end

  end