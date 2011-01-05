require 'bundler'

# Use vinfo tasks onto it self

$LOAD_PATH.unshift File.expand_path('./lib', File.dirname(__FILE__))

require 'version_info'
require 'version_info/version'


VersionInfo::Tasks.install(:class => VersionInfo)
# now we have VersionInfo::VERSION defined, can load this
Bundler::GemHelper.install_tasks

