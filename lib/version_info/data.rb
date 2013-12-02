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
      idx = segments.index(key.to_sym) + 1
      return unless idx
      segments[idx..-1].each do |sgm| 
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
      unless @tag_format
        fmts = segments.map { |k| "%<#{k}>s"}
        fmt_join = segments.map { |k| "." }
        fmt_join[2] = '+' if fmts.size > 2 #build uses '+'. See semver.org
        fmt_join[-1] = '' if fmt_join.size > 0 #remove last char
        @tag_format = fmts.zip(fmt_join).flatten.join
      end
        @tag_format
    end

    def tag_format=(value)
	    @tag_format = value
    end

    def set_version_info(tag_str)
      clear  
      values = tag_str.to_s.split(/\.|\+|\-/)
      values.each_with_index do |val, idx|
        val = val.to_s.chomp
        val = val.match(/(^\d+)$/) ? val.to_i : val
        self.send("#{VersionInfo.segment_at(idx)}=", val )
      end
    end

    def segments
      @table.keys
    end

    def clear
      segments.each{|key| delete_field(key)}
      @tag_format = nil
    end

    def get_defaults
      VersionInfo.segments.inject({}){|h, k| h[k] = 0; h}
    end   
  end
end

