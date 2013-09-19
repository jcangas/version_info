require 'yaml'

module VersionInfo
  # Version data is stored in a yaml file as a simple hash, i.e. :

  # --- 
  # major: 1
  # minor: 1
  # patch: 4
  # author: jcangas

  class YamlStorage < Storage
    def default_file_name
      'version_info.yml'
    end

    def load_from(io)
      values = YAML.load(io)
      # force keys as symbols
	    values.keys.each{|k| values[k.to_sym] = values.delete(k)}
      data.assign(values)
      self
    end

    def save_to(io)
	    values = data.to_hash.keys.compact.inject({}){|r, k| r[k.to_s] = data.send(k); r }
      YAML.dump(values, io)
	    self      
    end
  end
end
