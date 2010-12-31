## Usage:


Include VersionInfo in your main project module (or class):

    require 'version_info'

    module MyProject
      include VersionInfo

    end

Create a file to store your version data. By default the file is named version_info.yml:

    --- 
    major: 0
    minor: 1
    patch: 0
    author: jcangas


Note you can put any custom data. In order to get the version tag, VersionInfo reserve some special keys
for use as the "segments" of the version tag:

    module VersionInfo

      def self.segments
        [:major, :minor, :patch, :state, :build]
      end

      ...
    end

Usingh the previous version_info.yml:

    puts MyProject::VERSION.tag

    => 0.1.0

Also you can bump any segment. With the same sample:

    MyProject::VERSION.bump(:major)
    puts MyProject::VERSION.tag

    => 1.0.0

Note the other segments are reset to 0 after bump.
    
