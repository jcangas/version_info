require 'version_info/data'

module VersionInfo

  def self.segments
    [:major, :minor, :patch]
  end
   
  def self.included(other)
    # data = Class.new(Data)
    # other.const_set('Version', data)
    other.const_set('VERSION', Data.new)
  end

  autoload :RakeTasks, 'version_info/rake_tasks'
  autoload :ThorTasks, 'version_info/thor_tasks'

end


