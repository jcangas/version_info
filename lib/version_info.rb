require 'version_info/data'

module VersionInfo


  def self.segments
    [:major, :minor, :patch, :pre, :build]
  end
   
  def self.included(other)
    data = Class.new(Data)
    other.const_set('Version', data)
    other.const_set('VERSION', data.new)
  end

  autoload :Tasks, 'version_info/tasks'

end


