require 'spec_helper'

#require 'version_info/test_file'

describe "VersionInfo defaults" do

  before :each do
    @test_module = Module.new
    @test_module.send :include, VersionInfo

    @test_module::VERSION.file_name = nil
  end
  after :each do
    @test_module = nil
  end

  it "is initalized" do
    @test_module::VERSION.segments.should == [:major, :minor, :patch]
    @test_module::VERSION.to_hash.should == {:major => 0, :minor => 0, :patch => 0 }
    @test_module::VERSION.tag_format.should == "%<major>s.%<minor>s.%<patch>s"
  end

  it "can assign filename" do
    @test_module::VERSION.file_name = 'test_file.vinfo'
    @test_module::VERSION.file_name.should == 'test_file.vinfo'
  end

  it "has a minor property" do
    lambda {@test_module::VERSION.minor}.should_not raise_error
  end

  it "has a tag property" do
    lambda {@test_module::VERSION.tag}.should_not raise_error
  end

  it "tag has format" do
    @test_module::VERSION.tag.should == '0.0.0'    
    @test_module::VERSION.tag_format.should == "%<major>s.%<minor>s.%<patch>s"
  end

  it "tag format can be changed" do
    @test_module::VERSION.set_version_info('0.0.0.0')
    @test_module::VERSION.build_flag = 'pre'
    @test_module::VERSION.tag_format = "%<major>d.%<minor>d.%<patch>d-%<build_flag>s%<build>d"
    @test_module::VERSION.tag.should == '0.0.0-pre0'    
  end

  it "can bump a segment" do
    @test_module::VERSION.bump(:minor)
    @test_module::VERSION.bump(:patch)
    @test_module::VERSION.tag.should == '0.1.1'    
  end

  it "bump a segment reset semver sublevels " do
    @test_module::VERSION.set_version_info("1.2.3+B4.5")
    @test_module::VERSION.bump(:patch)
    @test_module::VERSION.bump(:minor)
    @test_module::VERSION.tag.should == "1.3.0+B4.5"   
  end

end

describe "VersionInfo custom segments" do
  before :each do
    VersionInfo.segments = [:a, :b, :c]
    @test_module = Module.new
      @test_module.send :include, VersionInfo
  end

  after :each do
    VersionInfo.segments = nil # reset defaults
  end    

  it "can be assigned" do
    @test_module::VERSION.to_hash.should == {:a => 0, :b => 0, :c => 0 }
   end

  it "segments are properties" do
    lambda{@test_module::VERSION.a}.should_not raise_error
   end

  it "can bump a custom segment" do
    @test_module::VERSION.bump(:c)
    @test_module::VERSION.bump(:b)
    @test_module::VERSION.tag.should == '0.1.0'    
  end
end


