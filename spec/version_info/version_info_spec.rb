require 'spec_helper'

#require 'version_info/test_file'

describe "VersionInfo defaults" do

  before :each do
    module TestFile
      include VersionInfo # force new VERSION value
    end
    TestFile::VERSION.file_name = nil
  end

  after :each do
    module TestFile
      remove_const :VERSION
    end
  end    

  it "is initalized" do
    TestFile::VERSION.to_hash.should == {:major => 0, :minor => 0, :patch => 0 }
  end

  it "can assign filename" do
    TestFile::VERSION.file_name = 'test_file.vinfo'
    TestFile::VERSION.file_name.should == 'test_file.vinfo'
  end

  it "has a minor property" do
    lambda {TestFile::VERSION.minor}.should_not raise_error
  end

  it "has a tag property" do
    lambda {TestFile::VERSION.tag}.should_not raise_error
  end

  it "tag has format" do
    TestFile::VERSION.tag.should == '0.0.0'    
  end

  it "tag format can be changed" do
    TestFile::VERSION.build_flag = 'pre'
    TestFile::VERSION.tag_format = TestFile::VERSION.tag_format + "--%<build_flag>s"
    TestFile::VERSION.tag.should == '0.0.0--pre'    
  end

  it "can bump a segment" do
    TestFile::VERSION.bump(:patch)
    TestFile::VERSION.tag.should == '0.0.1'    
  end

  it "bump a segment reset sublevels " do
    TestFile::VERSION.bump(:patch)
    TestFile::VERSION.bump(:minor)
    TestFile::VERSION.tag.should == '0.1.0'   
  end

end

describe "VersionInfo custom segments" do
  before :each do
    VersionInfo.segments = [:a, :b, :c]
    module TestFile
      include VersionInfo # force new VERSION value
    end
  end

  after :each do
    module TestFile
      remove_const :VERSION
    end
    VersionInfo.segments = nil # reset defaults
  end    

  it "can be assigned" do
    TestFile::VERSION.to_hash.should == {:a => 0, :b => 0, :c => 0 }
   end

  it "segments are properties" do
    lambda{TestFile::VERSION.a}.should_not raise_error
   end

  it "can bump a custom segment" do
    TestFile::VERSION.bump(:c)
    TestFile::VERSION.bump(:b)
    TestFile::VERSION.tag.should == '0.1.0'    
  end
end


