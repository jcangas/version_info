
module VersionInfo
  # Version data is stored in a text file with this structure
  # 2.2.3  # => numeric segments at first line
  # author: jcangas # => custom key after, one per line
  # email: jorge.cangas@gmail.com # => another custom key
  #
  # The convenion is to name this file "VERSION"
    
  class TextStorage < Storage
    
    def default_file_name
      'VERSION'
    end

    def load_content
      File.exist?(file_name) ? File.readlines(file_name) : [""]
    end
    
    def load
      content = load_content
      parse_from(content)
      self
    end

    def parse_from(content)
      str = content.shift
      custom = content.inject({}) {|result, line| k, v = line.chomp.split(':'); result[k.strip.to_sym] = v.strip; result}
      data.set_version_info(str)
      data.to_hash.merge!(custom)
      self
    end

    def save_to(io)
      io.puts data.tag #VersionInfo.segments.map{|sgm| data.send(sgm)}.join('.')
      data.to_hash.each {|k, v| io.puts "#{k}: #{v}" unless data.segments.include?(k) }
	    self      
    end
  end
end
