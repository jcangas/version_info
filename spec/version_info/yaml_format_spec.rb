require 'spec_helper'

describe "Yaml file format" do
  before :each do
    VersionInfo.file_format = :yaml
    TestFile = Module.new do
      include VersionInfo # force new VERSION value
    end
    TestFile::VERSION.file_name = nil
  end

  it "has default filename" do
    TestFile::VERSION.file_name.should ==  Dir.pwd + '/' + 'version_info.yml'
  end

  it "is initalized" do
    TestFile::VERSION.to_hash.should == {:major => 0, :minor => 0, :patch => 0 }
  end

  it "can save " do
    io = StringIO.new
    File.stub!(:open).and_yield(io)
    TestFile::VERSION.bump(:minor)
    TestFile::VERSION.save
    # Seems like YAML has removed one space in ruby 1.9.2p290
    # TODO: check for ruby 1.9.2
    if RUBY_PATCHLEVEL >= 290 
      io.string.should == "---\nmajor: 0\nminor: 1\npatch: 0\n"
    else
      io.string.should == "--- \nmajor: 0\nminor: 1\npatch: 0\n"
    end
  end

  it "can save custom data " do
    io = StringIO.new
    File.stub!(:open).and_yield(io)
    TestFile::VERSION.bump(:minor)
    TestFile::VERSION.author = 'jcangas'
    TestFile::VERSION.save
    if RUBY_PATCHLEVEL >= 290 # asume ruby 1.9.2
      io.string.should == "---\nmajor: 0\nminor: 1\npatch: 0\nauthor: jcangas\n" 
    else
      io.string.should == "--- \nmajor: 0\nminor: 1\npatch: 0\nauthor: jcangas\n" 
    end
  end

  it "can load " do
    io = StringIO.new("--- \nmajor: 1\nminor: 2\npatch: 3\n")
    File.should_receive(:read).and_return{io}
    TestFile::VERSION.load
    TestFile::VERSION.to_hash.should == {:major => 1, :minor => 2, :patch => 3 }  
  end

  it "can load custom data " do
    io = StringIO.new("--- \nmajor: 1\nminor: 2\npatch: 3\nauthor: jcangas\n")
    File.should_receive(:read).and_return{io}
    TestFile::VERSION.load
    TestFile::VERSION.to_hash.should == {:major => 1, :minor => 2, :patch => 3, :author => 'jcangas' }  
  end

end

