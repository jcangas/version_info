require 'version_info/data'

module VersionInfo


  def self.segments
    [:major, :minor, :patch, :pre, :build]
  end
   
  def self.included(other)         
    other.const_set('VERSION', Data.new)
  end

  autoload :Tasks, 'version_info/tasks'

end


