module VersionInfo
  Version = Class.new(Data)
  Version.file_name = 'lib/version_info/version_info.yml'

  VERSION = Version.new 
end

