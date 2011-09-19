require 'spec_helper'

describe "Module file format" do
  before :each do
    VersionInfo.file_format = :module

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
    @test_module.VERSION.major.should == 0
    @test_module.VERSION.minor.should == 0
    @test_module.VERSION.patch.should == 0
  end

  it "can assign VERSION" do
    @test_module.VERSION = '1.2.4'
    @test_module.VERSION.author = 'jcangas'    
    @test_module.VERSION.email = 'jorge.cangas@gmail.com'    
    @test_module.VERSION.class.name.should == 'VersionInfo::Data'
    @test_module.VERSION.to_hash.should == {major: 1, minor: 2, patch: 4, author: 'jcangas', email: 'jorge.cangas@gmail.com' }
  end

end
