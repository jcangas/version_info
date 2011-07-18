## VersionInfo

### Overview

  VersionInfo is a powerful and very lightweight gem to manage version data in your Ruby projects or gems. Very user friendly thanks to rake / thor tasks

####  Features

  * rake & thor tasks avaiables to yaml file creation, bump segments and show info

  * can define custom segments to build your version tag with the tipical structure X.X.X.X.

  * can use a custom tag format: do you want a tag like "1-3-1pre"?. No problem!.

  * can include any custom info in your version data.

  * Version data is stored in a yaml file.
  
  * good rspec tests


  Feel free to contact me about bugs/features

### Usage

Include VersionInfo in your main project module (or class):

    require 'version_info'

    module MyProject
      include VersionInfo
    end

From here, is better to use rake/thor tasks (see it forward). 

Here is how VersionInfo works and their user options:

After you included VersionInfo, a new constant MyProject::VERSION is created holding an object of class VersionInfo::Data

VersionInfo use yaml file to store version data:

    --- 
    major: 0
    minor: 1
    patch: 0
    author: jcangas

By default the file is named version_info.yml and stored in the current dir, useful
when using Rake or Thor.

Anyway, you can change this (recomended):
    module MyProject
      include VersionInfo
      VERSION.file_name = '/path/to/my_file.yaml'      
    end

Note you can put any custom data. In order to get the version tag, VersionInfo define the segments of the version tag. Here the source code:

    module VersionInfo

      # current segments or defaults
      def self.segments
        @segments ||= [:major, :minor, :patch] 
      end

      # define segments
      def self.segments=(values)
        @segments = values
      end

      ...
    end

Using the previous version_info.yml:

    puts MyProject::VERSION.tag

    => 0.1.0

Also you can bump any segment. With the same sample:

    MyProject::VERSION.bump(:major)
    puts MyProject::VERSION

    => 1.0.0

Note other "lower weight" segments are reset to 0.

### Bonus: Custom segments and tag format.

  You can override the default segments

    VersionInfo.segments = [:a, :b, :c]
    module MyProject
      include VersionInfo # force new VERSION value
    end

  Note this must be done **before** include VersionInfo.

 Also, tag format can be redefined. VersionInfo uses simple
sprintf in order to build the tag string. Here is the code:

    def tag
      tag_format % to_hash
    end

By default, tag_format, returns a simple sprintf format string,
using the segment names, expecting their values are numbers:

    def tag_format
	    @tag_format ||= VersionInfo.segments.map { |k| "%<#{k}>d"}.join('.')
    end

So tag_format return some like "%<major>d.%<minor>d%<patch>d".

If your VersionInfo yaml file is like:

    --- 
    major: 2
    minor: 1
    patch: 53
    buildflag: pre

You can change the tag format

    MyProject::VERSION.buildflag = 'pre'
    MyProject::VERSION.tag_format = MyProject::VERSION.tag_format + "--%<buildflag>s"
    puts MyProject::VERSION.tag # => '2.1.53--pre'    

### Rake / Thor tasks

Put in your rake file:

    VersionInfo::RakeTasks.install(:class => MyProject) # pass here the thing where you included VersionInfo

And you get a few tasks with a namespace vinfo:

    rake -T
    =>
    rake vinfo:build  # Bumps version segment BUILD
    rake vinfo:inspect  # Show complete version info
    rake vinfo:major  # Bumps version segment MAJOR
    rake vinfo:minor  # Bumps version segment MINOR
    rake vinfo:patch  # Bumps version segment PATCH
    rake vinfo:show   # Show current version tag and create version_info.yml if missing

If you prefer Thor:

    VersionInfo::ThorTasks.install(:class => MyProject) # pass here the thing where you included VersionInfo

    thor list
    =>

    vinfo
    -----
    thor vinfo:bump SEGMENT=patch  # bumps segment: [major, minor, patch, build]...
    thor vinfo:inspect             # Show complete version info
    thor vinfo:show                # Show version tag and create version_info.yml...

### Install

 VersionInfo is at [https://rubygems.org/gems/version_info](https://rubygems.org/gems/version_info) :

    gem install version_info

