require 'version_info/data'

module VersionInfo

  autoload :Tasks, 'version_info/tasks'

  def self.segments
    [:major, :minor, :patch, :state, :build]
  end
   
  def self.included(other)         
    other.const_set('VERSION', Data.new)
  end

end


