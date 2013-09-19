
module VersionInfo
  # Version data is stored in a ruby file into the project top module :

  # module MyProject
  #   VERSION = "0.0.1"
  #   VERSION.author = "jcangas"
  #   VERSION.email = "jorge.cangas@gmail.com"
  # end
  #
  # The convenion is to name this file "version.rb"

  class ModuleStorage < Storage

    def default_file_name
      'version.rb'
    end

    def load_from(io)
      self
    end

    def save      
      content = File.read(file_name)
      content.gsub!(/(\s*VERSION\s*=\s*)('|").*('|")/, "\\1\\2#{tag}\\3")
	    File.open(file_name, 'w' ) {|out| out.print content}
	    self
    end

  end

end

