
module VersionInfo
  # Version data is stored in a text file with this structure
  # 2.2.3  # => numeric segments at first line
  # author: jcangas # => custom key after, one per line
  # email: jorge.cangas@gmail.com # => another custom key
  #
  # The convenion is to name this file "VERSION"
    
  module TextStorage
    
    def default_file_name
      'VERSION'
    end

    def load_from(io)
      content = io.string.split("\n") unless io.is_a? Array
      str = content.shift
      custom = content.inject({}) {|result, line| k, v = line.chomp.split(':'); result[k.strip.to_sym] = v.strip; result}
      self.set_version_info(str)
      self.to_hash.merge!(custom)
      self
    end

    def save_to(io)
      io.puts VersionInfo.segments.map{|sgm| send(sgm)}.join('.')
      to_hash.each {|k, v| io.puts "#{k}: #{v}" unless VersionInfo.segments.include?(k) }
	    self      
    end
  end
end
