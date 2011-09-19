require 'yaml'

module VersionInfo
  # Version data is stored in a yaml file as a simple hash, i.e. :

  # --- 
  # major: 1
  # minor: 1
  # patch: 4
  # author: jcangas

  module YamlStorage
    def default_file_name
      'version_info.yml'
    end

    def load_from(io)
      values = YAML.load(io)
      # force keys as symbols
	    values.keys.each{|k| values[k.to_sym] = values.delete(k)}
      assign(values)
      self
    end

    def save_to(io)
	    values = self.to_hash.keys.compact.inject({}){|r, k| r[k.to_s] = send(k); r }
      YAML.dump(values, io)
	    self      
    end
  end
end
