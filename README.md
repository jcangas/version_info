## VersionInfo

### Overview

  VersionIinfo is a powerful and very lightweight gem to manage version data in your Ruby projects or other gems.

  VersionIinfo can manage a serie of predefined segments to build your version tag with the tipical structure X.X.X.X.
  Their values are stored in a yaml file, and supports custom values. 

  Also rake & thor tasks are avaiable to simplify yaml file creation and update.

  Feel free to contact me about bugs/features

### Usage

Include VersionInfo in your main project module (or class):

    require 'version_info'

    module MyProject
      include VersionInfo
    end

From here, is better to use the builtin rake/thor tasks (see it fordward). Here is how VersionInfo works and their user options:

After you included VersionIinfo, a new class MyProject::Version is defined (it inherit from VersionIinfo::Data). Also a new constant MyProject::VERSION is created holding an object of class MyProject::VersionIinfo.

VersionInfo use yaml file to store version data:

    --- 
    major: 0
    minor: 1
    patch: 0
    author: jcangas

By default the file is named version_info.yml and stored near the main file with the include VersionIinfo thing.

Anyway, you can change this:
    module MyProject
      include VersionInfo
      VERISION.file_name = '/path/to/my_file.yaml'      
    end

Note you can put any custom data. In order to get the version tag, VersionInfo reserve some special keys for use as the "segments" of the version tag. Here the source code:

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
    puts MyProject::VERSION

    => 1.0.0

Note the other (lower weight) segments are reset to 0 after bump.

### Rake / Thor tasks

Put in your rake file:

    VersionInfo::RakeTasks.install(:class => MyProject) # use the thing where you included VersionInfo

And you get a few tasks with a namespace vinfo:

    rake -T
    =>
    rake vinfo:build  # Bumps version segment BUILD
    rake vinfo:inspect  # Show complete version info
    rake vinfo:major  # Bumps version segment MAJOR
    rake vinfo:minor  # Bumps version segment MINOR
    rake vinfo:patch  # Bumps version segment PATCH
    rake vinfo:show   # Show current version tag and create version_info.yml if missing

Or, if you prefer Thor:

    VersionInfo::ThorTasks.install(:class => MyProject) # use the thing where you included VersionInfo

    thor list
    =>

    vinfo
    -----
    thor vinfo:bump SEGMENT=patch  # bumps segment: [major, minor, patch, build]...
    thor vinfo:inspect             # Show complete version info
    thor vinfo:show                # Show version tag and create version_info.yml...

### Install

    gem install version_info

