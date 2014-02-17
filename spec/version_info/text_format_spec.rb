require 'spec_helper'

describe "Text file format" do
  before :each do
    VersionInfo.file_format = :text
    VersionInfo.segments = nil
    @test_module = Module.new
    @test_module.send :include, VersionInfo
    @test_module::VERSION.file_name = nil
  end

  it "has default filename" do
    @test_module::VERSION.file_name.should == Dir.pwd + '/' + 'VERSION'
  end

  it "is initalized" do
    @test_module::VERSION.to_hash.should == {:major => 0, :minor => 0, :patch => 0 }
  end

  it "can save " do
    io = StringIO.new
    File.should_receive(:open).and_yield(io)
    @test_module::VERSION.bump(:minor)
    @test_module::VERSION.save
    io.string.should == "0.1.0\n"
  end

  it "can save custom data " do
    io = StringIO.new
    File.should_receive(:open).and_yield(io)
    @test_module::VERSION.bump(:minor)
    @test_module::VERSION.author = 'jcangas'
    @test_module::VERSION.email = 'jcangas@example.com'
    @test_module::VERSION.save
    io.string.should == <<END
0.1.0
author: jcangas
email: jcangas@example.com
END

  end

  it "can load " do
    content = ["1.2.3"]
    @test_module::VERSION.storage.should_receive(:load_content).and_return(content)
    @test_module::VERSION.load
    @test_module::VERSION.to_hash.should == {:major => 1, :minor => 2, :patch => 3}  
  end

  it "auto add segments on load" do
    content = ["1.2.3.B4.5"]
    @test_module::VERSION.storage.should_receive(:load_content).and_return(content)
    @test_module::VERSION.load
    @test_module::VERSION.to_hash.should == {:major => 1, :minor => 2, :patch => 3, :build => 'B4', :vinfo4 => 5  }  
  end

  it "can save custom tag format" do
    @test_module::VERSION.set_version_info("1.2.3+B4.5")
    io = StringIO.new
    File.should_receive(:open).and_yield(io)
    @test_module::VERSION.save
    io.string.should == <<END
1.2.3+B4.5
END
  end

  it "auto add build segment uses semvar.org tag format " do
    content = ["1.2.3.B4.5"]
    @test_module::VERSION.storage.should_receive(:load_content).and_return(content)
    @test_module::VERSION.load
    @test_module::VERSION.tag.should == "1.2.3+B4.5"  
  end

  it "can load custom data " do
    content = ["1.2.3+B4.5","author: jcangas"]
    @test_module::VERSION.storage.should_receive(:load_content).and_return(content)
    @test_module::VERSION.load
    @test_module::VERSION.to_hash.should == {:major => 1, :minor => 2, :patch => 3, :build => 'B4', :vinfo4 => 5, :author => 'jcangas' }  
  end
end
