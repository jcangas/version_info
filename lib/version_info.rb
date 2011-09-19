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

  def self.file_format
    @file_format ||= :module
  end
  
  def self.install_tasks(options)
    if defined?(:Rake)
      require 'version_info/rake_tasks' 
      RakeTasks.install(options) 
    elsif defined?(:Thor)
      require 'version_info/thor_tasks'
      ThorTasks.install(options)
    end
  end

  def self.file_format=(value)
    @file_format = value
  end

  def self.included(other)
    self.versionable(other)
  end

  def self.versionable(other)
    data = Data.new
    if File.exist?(data.file_name)
        data.load
      end

    other.const_set('VERSION', data)
    singleton = class << other; self; end
    singleton.class_eval do
      define_method :VERSION do
        self::VERSION
      end    

      define_method :"VERSION=" do |value_str|
        self::VERSION.set_version_info(value_str)
      end    
    end
  end

end


