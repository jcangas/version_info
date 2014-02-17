module VersionInfo
  class Storage
    
    def initialize(data)
      super()
      @data = data
    end
    
    def data
      @data
    end

    def file_name
      @data.file_name
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

