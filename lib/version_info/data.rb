require 'ostruct'

module VersionInfo
  STORAGE_CLASS = {text: TextStorage, yaml: YamlStorage, module: ModuleStorage}
  class Data < OpenStruct
    def initialize(segments)
      super()
      @segments = segments
      reset
    end
    
    def storage
      unless @storage
        @storage ||= STORAGE_CLASS[VersionInfo.file_format.to_sym].new(self)
      end
      @storage
    end
    
    def file_name
      @file_name ||= Dir.pwd + '/' + storage.default_file_name
    end

    def file_name=(value)
      @file_name = value
      @storage = nil #recreate storage
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
      clear
      assign(get_defaults)
    end
    
    def assign(hash)
      marshal_load(hash)    
    end

    def bump(key)
      idx = segments.index(key.to_sym) + 1
      return unless idx
      segments[idx..2].each do |sgm| 
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
        fmt_join = fmts.map { |k| "." }
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
        self.send("#{segment_at(idx)}=", val )
      end
      self
    end

    def segment_at(idx)
      @segments << :build if (@segments.size == 3) && (idx>=3)
      (@segments.size..idx).each{|n| @segments << "vinfo#{n}".to_sym}
      @segments[idx]
    end

    def segments
      @segments
    end

    def clear
      segments.each{|key| delete_field(key) if @table.has_key?(key)}
      @tag_format = nil
    end

    def get_defaults
      segments.inject({}){|h, k| h[k] = 0; h}
    end   
  end
end

