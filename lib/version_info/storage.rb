module VersionInfo
  class Storage
    attr :data
    
    def initialize(data)
      super()
      @data = data
    end
    
    def file_name
      @file_name ||= Dir.pwd + '/' + default_file_name
      load if @file_name && File.exist?(@file_name)
      @file_name
    end

    def file_name=(value)
      @file_name = value
    end

    def load
      File.open(file_name, 'r') {|io| load_from(io)}
      self
    end

    def save      
	    File.open(file_name, 'w' ) {|out| save_to(out)}
	    self
    end
  end
end

require 'version_info/text_storage'
require 'version_info/yaml_storage'
require 'version_info/module_storage'

