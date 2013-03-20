require 'spec_helper'

describe "Yaml file format" do
  before :each do
    VersionInfo.file_format = :yaml
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
    # TODO: check for ruby 1.9.2
    if RUBY_VERSION == "1.9.2" && RUBY_PATCHLEVEL < 290 
      io.string.should == "--- \nmajor: 0\nminor: 1\npatch: 0\n"
    else
      io.string.should == "---\nmajor: 0\nminor: 1\npatch: 0\n"
    end
  end

  it "can save custom data " do
    io = StringIO.new
    File.should_receive(:open).and_yield(io)
    @test_module::VERSION.bump(:minor)
    @test_module::VERSION.author = 'jcangas'
    @test_module::VERSION.save
    if RUBY_VERSION == "1.9.2" && RUBY_PATCHLEVEL < 290 
      io.string.should == "--- \nmajor: 0\nminor: 1\npatch: 0\nauthor: jcangas\n" 
    else
      io.string.should == "---\nmajor: 0\nminor: 1\npatch: 0\nauthor: jcangas\n" 
    end
  end

  it "can load " do
    io = StringIO.new("--- \nmajor: 1\nminor: 2\npatch: 3\n")
    File.should_receive(:open).and_yield(io)
    @test_module::VERSION.load
    @test_module::VERSION.to_hash.should == {:major => 1, :minor => 2, :patch => 3 }  
  end

  it "can load custom data " do
    io = StringIO.new("--- \nmajor: 1\nminor: 2\npatch: 3\nauthor: jcangas\n")
    File.should_receive(:open).and_yield(io)
    @test_module::VERSION.load
    @test_module::VERSION.to_hash.should == {:major => 1, :minor => 2, :patch => 3, :author => 'jcangas' }  
  end

end

