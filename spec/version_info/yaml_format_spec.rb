require 'spec_helper'

describe "Yaml file format" do
  before :each do
    VersionInfo.file_format = :yaml
    VersionInfo.segments = nil
    @test_module = Module.new
    @test_module.send :include, VersionInfo
    @test_module::VERSION.file_name = nil
  end

  it "has default filename" do
    @test_module::VERSION.file_name.should ==  Dir.pwd + '/' + 'version_info.yml'
  end

  it "is initalized" do
    @test_module::VERSION.to_hash.should == {:major => 0, :minor => 0, :patch => 0 }
  end

  it "can save " do
    io = StringIO.new
    File.should_receive(:open).and_yield(io)
    @test_module::VERSION.bump(:minor)
    @test_module::VERSION.save
    # Seems like YAML has removed one space in ruby 1.9.2p290
    io.string.should == "---\nmajor: 0\nminor: 1\npatch: 0\n"
  end

  it "can save custom data " do
    io = StringIO.new
    File.should_receive(:open).and_yield(io)
    @test_module::VERSION.bump(:minor)
    @test_module::VERSION.author = 'jcangas'
    @test_module::VERSION.save
    io.string.should == "---\nmajor: 0\nminor: 1\npatch: 0\nauthor: jcangas\n" 
  end

  it "can load " do
    content = ["--- ", "major: 1", "minor: 2", "patch: 3"]
    @test_module::VERSION.storage.should_receive(:load_content).and_return(content)
    @test_module::VERSION.load
    @test_module::VERSION.to_hash.should == {:major => 1, :minor => 2, :patch => 3 }  
  end

  it "can load custom data " do
    content = ["--- ", "major: 1", "minor: 2", "patch: 3", "author: jcangas"]
    @test_module::VERSION.storage.should_receive(:load_content).and_return(content)
    @test_module::VERSION.load
    @test_module::VERSION.to_hash.should == {:major => 1, :minor => 2, :patch => 3, :author => 'jcangas' }  
  end

end

