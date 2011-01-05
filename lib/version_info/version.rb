module VersionInfo
  Version = Class.new(Data)

  VERSION = Version.new 
  VERSION.file_name = 'lib/version_info/version_info.yml'
end

