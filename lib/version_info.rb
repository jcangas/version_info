require 'version_info/data'

module VersionInfo

  # current segments or defaults
  def self.segments
    @segments ||= [:major, :minor, :patch] 
  end

  # define segments
  def self.segments=(values)
    @segments = values
  end
   
  def self.included(other)
    other.const_set('VERSION', Data.new)
  end

  autoload :RakeTasks, 'version_info/rake_tasks'
  autoload :ThorTasks, 'version_info/thor_tasks'

end


