module VersionInfo
  class Storage
    attr :data
    
    def initialize(data)
      super()
      @data = data
      load if file_name && File.exist?(file_name)
    end
    
    def file_name
      @file_name ||= Dir.pwd + '/' + default_file_name
    end

    def file_name=(value)
      @file_name = value
    end

    def load_content
      File.exist?(file_name) ? File.readlines(file_name) : [""]
    end
    
    def load
      content = load_content
      parse_from(content)
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

