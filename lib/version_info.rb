require 'version_info/storage'
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
  
  def self.file_format=(value)
    @file_format = value
  end

  def self.install_tasks(options)
    if defined?(Rake)
      require 'version_info/rake_tasks' 
      RakeTasks.install(options) 
    elsif defined?(Thor)
      require 'version_info/thor_tasks'
      ThorTasks.install(options)
    end
  end

  def self.included(other)
    self.versionable(other)
  end

  def self.versionable(other)
    if other.const_defined?(:VERSION, false)
      old_const = other.const_get(:VERSION, false) 
      other.send(:remove_const, :VERSION) rescue true
    end
    other.const_set(:VERSION, Data.new(VersionInfo.segments.dup))
    singleton = other.singleton_class
    singleton.class_eval do
      define_method :VERSION do
        @data ||= self::VERSION
      end    
      define_method :"VERSION=" do |value_str|
        self.VERSION.set_version_info(value_str)
      end    
    end
    other.VERSION= old_const.to_s if old_const
  end

end


