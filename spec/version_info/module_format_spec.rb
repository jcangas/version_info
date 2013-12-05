require 'spec_helper'

describe "Module file format" do
  before :each do
    VersionInfo.file_format = :module
    VersionInfo.segments = nil
    @test_module = Module.new
    @test_module.send :include, VersionInfo # force new VERSION value
    @test_module::VERSION.file_name = nil
  end

  it "has accessor " do
    @test_module.should respond_to("VERSION")
  end

  it "has mutator " do
    @test_module.should respond_to("VERSION=")
  end

  it "has default filename" do
    @test_module.VERSION.file_name.should ==  Dir.pwd + '/' + 'version.rb'
  end

  it "is initalized" do
    @test_module.VERSION.to_hash.should == {:major => 0, :minor => 0, :patch => 0 }
  end

  it "has segmentes" do
    @test_module.VERSION.segments.should == [:major, :minor, :patch]
  end

  it "can assign VERSION" do
    @test_module.VERSION = '1.2.4'
    @test_module.VERSION.author = 'jcangas'    
    @test_module.VERSION.email = 'jcangas@example.com'    
    @test_module.VERSION.class.name.should == 'VersionInfo::Data'
    @test_module.VERSION.to_hash.should == {major: 1, minor: 2, patch: 4, author: 'jcangas', email: 'jcangas@example.com' }
  end

  it "can use tag" do
    @test_module.VERSION = "1.2.4"
    @test_module.VERSION.tag.should == "1.2.4"
  end

  it "can save " do
    content = <<END
module Test
  include VersionInfo
  self.VERSION = "#{@test_module.VERSION.tag}"
  self.VERSION.file_name = __FILE__
end
END
    File.should_receive(:read).and_return(content)
    io = StringIO.new
    File.should_receive(:open).and_yield(io)
    @test_module::VERSION.bump(:minor)
    @test_module::VERSION.storage.data.tag.should ==  "0.1.0"
    @test_module::VERSION.save
    io.string.should == <<END
module Test
  include VersionInfo
  self.VERSION = "#{@test_module.VERSION.tag}"
  self.VERSION.file_name = __FILE__
end
END
  end

end
