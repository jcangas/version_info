require 'ostruct'
module VersionInfo
  class Data < OpenStruct
    attr_accessor :file_name	

    def initialize
      super
      if File.exist?(file_name)
        load
      else
        marshal_load(get_defaults)
      end
    end

    def file_name
      @file_name ||= 'version_info.yml'
    end

    def bump(key)
      idx = VersionInfo.segments.index(key.to_sym) + 1
      return unless idx
      VersionInfo.segments[idx..-1].each do |sgm| 
	      send("#{sgm}=", 0) if send(sgm)
      end
      send("#{key}=", 1 + send(key))
    end
    
    def load
      load_from(File.read(file_name))
	    self
    end

    def save      
	    File.open( file_name, 'w' ) {|out| save_to(out)}
	    self
    end

    def tag
	    VersionInfo.segments.map { |k| send(k) }.compact.join('.')
    end

  protected
    def get_defaults
      VersionInfo.segments[0..2].inject({}){|h, k| h[k] = 0; h}
    end
   
    def load_from(io)
      values = YAML.load(io)
	    values.keys.each{|k, v| values[k.to_sym] = values.delete(k)}
      marshal_load(values)
      self
    end

    def save_to(io)
	    values = self.marshal_dump.keys.compact.inject({}){|r, k| r[k.to_s] = send(k); r }
      YAML.dump(values, io )
	    self      
    end
  end
end
