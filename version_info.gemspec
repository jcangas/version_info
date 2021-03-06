$:.push File.expand_path("../lib", __FILE__)
require "version_info"
require "version_info/version"

Gem::Specification.new do |s|
  s.name        = "version_info"
  s.version     = VersionInfo::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jorge L. Cangas"]
  s.license = 'MIT'
  s.email       = ["jorge.cangas@gmail.com"]
  s.homepage    = "http://github.com/jcangas/version_info"
  s.summary     = %q{A Ruby gem to manage your project version data. Rake tasks included!}
  s.description = %q{Easy way to get version label, bump the segments (major, minor, patch), and you can include custom version data}

  s.rubyforge_project = "version_info"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency "bundler"  
  s.add_development_dependency "rake"  
  s.add_development_dependency "rspec"  
  s.add_development_dependency "test_notifier"  
  s.add_development_dependency "notifier"  
  s.add_development_dependency "coveralls"  
end
