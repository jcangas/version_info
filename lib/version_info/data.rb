require 'ostruct'

module VersionInfo

  class Data < OpenStruct

    def initialize
      super
      case VersionInfo.file_format.to_s
        when 'text'
          require 'version_info/text_storage'
          extend(TextStorage)
        when 'yaml' 
          require 'version_info/yaml_storage'
          extend(YamlStorage)
        else # asume 'module'
          require 'version_info/module_storage'
          extend(ModuleStorage)          
      end
      reset
      file_name = nil
    end

    def file_name
      @file_name ||= Dir.pwd + '/' + default_file_name
    end

    def file_name=(value)
      @file_name = value
      load if self.file_name && File.exist?(self.file_name)
    end

    def reset
      assign(get_defaults)
    end
    
    def assign(hash)
      marshal_load(hash)    
    end

    def bump(key)
      idx = VersionInfo.segments.index(key.to_sym) + 1
      return unless idx
      VersionInfo.segments[idx..-1].each do |sgm| 
	      send("#{sgm}=", 0) if send(sgm)
      end
      send("#{key}=", 1 + send(key).to_i)
    end
    
    def load
      load_from(File.read(file_name))
	    self
    end

    def save      
	    File.open(file_name, 'w' ) {|out| save_to(out)}
	    self
    end

    def to_s
      tag
    end
    
    def to_hash
      marshal_dump
    end

    def tag
      tag_format % to_hash
    end
    
    def tag_format
	    @tag_format ||= VersionInfo.segments.map { |k| "%<#{k}>d"}.join('.')
    end

    def tag_format=(value)
	    @tag_format = value
    end

    def set_version_info(tag_str)
      values = tag_str.split('.')
      VersionInfo.segments.each{|sgm|	self.send("#{sgm}=", values.shift.match(/(\d+)/).to_s.to_i) }
    end

    def get_defaults
      VersionInfo.segments[0..2].inject({}){|h, k| h[k] = 0; h}
    end   
  end
end

