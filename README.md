## VersionInfo

### Travis CI status

[![Build Status](https://secure.travis-ci.org/jcangas/version_info.png)](http://travis-ci.org/jcangas/version_info)

### Install

 VersionInfo is at [https://rubygems.org/gems/version_info](https://rubygems.org/gems/version_info), so:

    gem install version_info

### Usage

VersionInfo is a powerful and lightweight gem to manage version data in your Ruby projects or gems.
And is very user friendly thanks to rake / thor tasks: 

First, include VersionInfo in your main project module (or class):

```ruby
    require 'version_info'

    module MyProject
      VERSION = "1.5.0"

      include VersionInfo
      VERSION.file_name = __FILE__ 
    end
```

Then use rake/thor tasks:

    rake vinfo:minor
 
=> version changed to 1.6.0

Please, note here VersionInfo is included *after* the constant VERSION, if you don't like this also works

```ruby
    module MyProject
      include VersionInfo
      self.VERSION = "1.5.0"
      VERSION.file_name = __FILE__ 
    end
```

Please note here you are invoking a singleton method and not using a constant. When included VersionInfo
does a bit of magic and then you can use *both* the method and the constant:

```ruby
    MyProject.VERSION  # it works
    MyProject::VERSION # also works
```

One more sample:

```ruby
    Gem::Specification.new do |s|
      s.name        = "my_gem"
      s.version     = MyGem::VERSION
      s.platform    = Gem::Platform::RUBY
```

After VersionInfo is included, the singleton method and the constant returns a object of class VersionInfo::Data.
You can use some methods from it, (#bump, #to_s, #tag, etc.). Also you get another singleton method to easy assignment:

```ruby
    MyProject.VERSION= "2.0.2"  # also works
```

####  Features

* rake & thor tasks avaiables to yaml file creation, bump segments and show info

* can define custom segments to build your version tag with the tipical structure X.X.X.X.

* can use a custom tag format: do you want a tag like "1-3-1pre"?. No problem!.

* can include any custom info in your version data.

* good rspec tests

* Flexible formats for stored your version data:
  
1. Using a text file. Content of your version.rb file:

```ruby
   VersionInfo.file_format= :text    
   module MyProject
     include VersionInfo
     VERSION.file_name = /some_path/your_version_file #convenient but optional for this format
   end
```

The file is created "on demand". For example, you can invoke the task vinfo:show
The version data file is named by default VERSION and looks like. 

```
2.2.3
   author: jcangas
   email: jorge.cangas@gmail.com
```
  
2. Using a yaml file, as a hash. Content of your version.rb file:

```ruby
   VersionInfo.file_format= :yaml    
   module MyProject
     include VersionInfo
     VERSION.file_name = /some_path/your_file.yaml #convenient but optional for this format
   end
```

The file is created "on demand". For example, you can invoke the task vinfo:show
The version data file is named by default VERSION and looks like. 

```yaml
--- 
 	major: 1
 	minor: 1
 	patch: 4
 	author: jcangas
```

3. Using a ruby source (default). Content of your version.rb file:

```ruby
   module MyProject
     include VersionInfo
     self.VERSION = "1.5.0"
     VERSION.file_name = __FILE__ # required for this format
   end
```
  
You write this file. and no version data file is needed: VERSION const is already here (you see it, isn't?) 


Pleae, feel free to contact me about bugs/features

### Rake / Thor tasks

Put in your rake or thor file:

```ruby
    VersionInfo::install_tasks(:target => MyProject) # pass here the thing where you included VersionInfo
```

And you get a few tasks with a namespace vinfo:

    rake -T
    =>
    rake vinfo:file  # Show version file format & name
    rake vinfo:inspect  # Show complete version info
    rake vinfo:major  # Bumps version segment MAJOR
    rake vinfo:minor  # Bumps version segment MINOR
    rake vinfo:patch  # Bumps version segment PATCH
    rake vinfo:show   # Show current version tag and create version_info.yml if missing
        

    thor list
    =>

    vinfo
    -----
    rake vinfo:file  # Show version file format & name
    thor vinfo:bump SEGMENT=patch  # bumps segment: [major, minor, patch, build]...
    thor vinfo:inspect             # Show complete version info
    thor vinfo:show                # Show version tag and create version_info.yml...

Note all tasks works with any version format file!!. So is very easy to migrate for one to the other.

### Bonus: Custom segments and tag format.

  You can override the default segments

```ruby
   VersionInfo.segments = [:a, :b, :c]
   module MyProject
     include VersionInfo
   end
```

  Note this must be done **before** include VersionInfo.

 Also, tag format can be redefined. VersionInfo uses simple
sprintf in order to build the tag string. Here is the code:

```ruby
    def tag
      tag_format % to_hash
    end
```

By default, tag_format, returns a simple sprintf format string,
using the segment names, expecting their values are numbers:

```ruby
   def tag_format
     @tag_format ||= VersionInfo.segments.map { |k| "%<#{k}>d"}.join('.')
   end
```

So tag_format return some like "%\<major\>d.%\<minor\>d%\<patch\>d".

If your VersionInfo yaml file is like:

```yaml
    --- 
    major: 2
    minor: 1
    patch: 53
    buildflag: pre
```

You can change the tag format in this way

```ruby
    MyProject::VERSION.buildflag = 'pre'
    MyProject::VERSION.tag_format = MyProject::VERSION.tag_format + "--%<buildflag>s"
    puts MyProject::VERSION.tag # => '2.1.53--pre'    
```

