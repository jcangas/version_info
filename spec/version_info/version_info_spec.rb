require 'spec_helper'

require 'version_info/test_file'

describe "VersionInfo defaults" do

  before :each do
    module TestFile
      include VersionInfo # force new VERSION value
    end
  end

  after :each do
    module TestFile
      remove_const :VERSION
    end
  end    

  it "is initalized" do
    TestFile::VERSION.marshal_dump.should == {:major => 0, :minor => 0, :patch => 0 }
  end

  it "has default filename" do
    TestFile::VERSION.file_name.should ==  Dir.pwd + '/version_info.yml'
  end

  it "can assign filename" do
    TestFile::VERSION.file_name = 'test_file.vinfo'
    TestFile::VERSION.file_name.should == 'test_file.vinfo'
  end

  it "has a minor property" do
    TestFile::VERSION.minor.should == 0
  end

  it "has a tag property" do
    TestFile::VERSION.tag.should == '0.0.0'    
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

  it "can save " do
    io = StringIO.new
    File.stub!(:open).and_yield(io)
    TestFile::VERSION.bump(:minor)
    TestFile::VERSION.save
    io.string.should == "--- \nmajor: 0\nminor: 1\npatch: 0\n"
  end

  it "can save custom data " do
    io = StringIO.new
    File.stub!(:open).and_yield(io)
    TestFile::VERSION.bump(:minor)
    TestFile::VERSION.author = 'jcangas'
    TestFile::VERSION.save
    io.string.should == "--- \nmajor: 0\nminor: 1\npatch: 0\nauthor: jcangas\n"
  end

  it "can load " do
    io = StringIO.new("--- \nmajor: 1\nminor: 2\npatch: 3\n")
    File.should_receive(:read).and_return{io}
    TestFile::VERSION.load
    TestFile::VERSION.marshal_dump.should == {:major => 1, :minor => 2, :patch => 3 }  
  end

  it "can load custom data " do
    io = StringIO.new("--- \nmajor: 1\nminor: 2\npatch: 3\nauthor: jcangas\n")
    File.should_receive(:read).and_return{io}
    TestFile::VERSION.load
    TestFile::VERSION.marshal_dump.should == {:major => 1, :minor => 2, :patch => 3, :author => 'jcangas' }  
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
  end    

  it "can be assigned" do
    TestFile::VERSION.marshal_dump.should == {:a => 0, :b => 0, :c => 0 }
   end

  it "segments are properties" do
    TestFile::VERSION.a.should == 0
   end

  it "can bump a custom segment" do
    TestFile::VERSION.bump(:c)
    TestFile::VERSION.bump(:b)
    TestFile::VERSION.tag.should == '0.1.0'    
  end
end
