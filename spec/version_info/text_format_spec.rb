require 'spec_helper'

describe "Text file format" do
  before :each do
    VersionInfo.file_format = :text
    module TestFile
      include VersionInfo # force new VERSION value
    end
    TestFile::VERSION.file_name = nil
  end


  it "has default filename" do
    TestFile::VERSION.file_name.should ==  Dir.pwd + '/' + 'VERSION'
  end

  it "is initalized" do
    TestFile::VERSION.to_hash.should == {:major => 0, :minor => 0, :patch => 0 }
  end

  it "can save " do
    io = StringIO.new
    File.stub!(:open).and_yield(io)
    TestFile::VERSION.bump(:minor)
    TestFile::VERSION.save
    io.string.should == "0.1.0\n"
  end

  it "can save custom data " do
    io = StringIO.new
    File.stub!(:open).and_yield(io)
    TestFile::VERSION.bump(:minor)
    TestFile::VERSION.author = 'jcangas'
    TestFile::VERSION.email = 'jorge.cangas@gmail.com'
    TestFile::VERSION.save
    io.string.should == <<END
0.1.0
author: jcangas
email: jorge.cangas@gmail.com
END

  end

  it "can load " do
    io = StringIO.new("1.2.3")
    File.should_receive(:read).and_return{io}
    TestFile::VERSION.load
    TestFile::VERSION.to_hash.should == {:major => 1, :minor => 2, :patch => 3 }  
  end

  it "can load custom data " do
    io = StringIO.new("1.2.3\nauthor: jcangas\n")
    File.should_receive(:read).and_return{io}
    TestFile::VERSION.load
    TestFile::VERSION.to_hash.should == {:major => 1, :minor => 2, :patch => 3, :author => 'jcangas' }  
  end

end
