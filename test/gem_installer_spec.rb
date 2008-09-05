require 'test/spec'

require '../lib/gem_installer'

describe 'GemInstaller' do
  it "parses simple gem name" do
    gems = GemInstaller.convert_gem_list("daemons (1.0.10)")
    gems.first.name.should == "daemons"
  end
  
  it "parses name with dashes" do
    gems = GemInstaller.convert_gem_list("diff-lcs (1.0.10)")
    gems.first.name.should == "diff-lcs"
  end

  it "parses name with underscores" do
    gems = GemInstaller.convert_gem_list("spec_converter_foo (1.0.10)")
    gems.first.name.should == "spec_converter_foo"
  end

  it "parses with multiple versions" do
    gems = GemInstaller.convert_gem_list("foo (1.0.10, 1.0.11)")
    gems[0].version.should == "1.0.10"
    gems[1].version.should == "1.0.11"
  end
  
end