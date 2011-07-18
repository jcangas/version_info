require 'ostruct'
require 'yaml'

module VersionInfo
  class Data < OpenStruct

    def initialize
      super
      if File.exist?(file_name)
        load
      else
        reset
      end
    end

    def file_name
      @file_name ||= Dir.pwd + '/' + 'version_info.yml'
    end

    def file_name=(value)
      @file_name = value
      load if File.exist?(@file_name)
    end

    def reset
      marshal_load(get_defaults)
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

  protected
    def get_defaults
      VersionInfo.segments[0..2].inject({}){|h, k| h[k] = 0; h}
    end
   
    def load_from(io)
      values = YAML.load(io)
      # force keys as symbols
	    values.keys.each{|k| values[k.to_sym] = values.delete(k)}
      marshal_load(values)
      self
    end

    def save_to(io)
	    values = self.marshal_dump.keys.compact.inject({}){|r, k| r[k.to_s] = send(k); r }
      YAML.dump(values, io)
	    self      
    end
  end
end
