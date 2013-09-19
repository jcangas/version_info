require 'ostruct'

module VersionInfo
  STORAGE_CLASS = {text: TextStorage, yaml: YamlStorage, module: ModuleStorage}
  class Data < OpenStruct
    def initialize
      super
      reset
    end
    
    def storage
      @storage ||= STORAGE_CLASS[VersionInfo.file_format.to_sym].new(self)
    end
    
    def file_name
      storage.file_name      
    end

    def file_name=(value)
      @storage = nil #recreate storage
      storage.file_name = value
    end
    
    def load
      storage.load
      self
    end
    
    def save
      storage.save
      self
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
      values = tag_str.to_s.split('.')
      VersionInfo.segments.each{|sgm| self.send("#{sgm}=", values.shift.match(/(\d+)/).to_s.to_i) }
    end

    def get_defaults
      VersionInfo.segments[0..2].inject({}){|h, k| h[k] = 0; h}
    end   
  end
end

