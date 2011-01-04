### Overview

  VersionIinfo is a powerful and very lightweight gem to manage version data in your Ruby projects or other gems.
  VersionIinfo can manage a serie of predefined segments to build your version tag with the tipical structure X.X.X.X.
  The values are stored in a yaml file, and supports custom values. Also, rake tasks are avaiable to simplify yaml file 
  creation and updates.

  Feel free to contact me about bugs/features

### Usage


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

    puts MyProject::VERSION

    => 0.1.0

Also you can bump any segment. With the same sample:

    MyProject::VERSION.bump(:major)
    puts MyProject::VERSION

    => 1.0.0

Note the other (lower) segments are reset to 0 after bump.


### Rake tasks

Put in your rake file:

    VersionInfo::Tasks.install

And you get a few tasks within namespace vinfo:

    rake -T
    =>
    rake vinfo:build  # Bumps version segment BUILD
    rake vinfo:major  # Bumps version segment MAJOR
    rake vinfo:minor  # Bumps version segment MINOR
    rake vinfo:patch  # Bumps version segment PATCH
    rake vinfo:pre    # Bumps version segment PRE
    rake vinfo:show   # Show current version tag and create version_info.yml if missing

### Install

    gem install version_info


