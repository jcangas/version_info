require 'bundler'

# Use vinfo tasks onto it self

$LOAD_PATH.unshift File.expand_path('./lib', File.dirname(__FILE__))

require 'version_info'
require 'version_info/version'


VersionInfo::RakeTasks.install(:class => VersionInfo)

# now we have VersionInfo::VERSION defined, can load this
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

desc "run specs"
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
  t.pattern = 'spec/**/*_spec.rb'
end

task :default  => :spec
