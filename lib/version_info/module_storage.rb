
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

    def parse_from(content)
      match = content.join("\n").match /(\s*VERSION\s*=\s*)('|")(.*)('|")/
      str = match[3]
      data.set_version_info(str)
      self
    end

    def save      
      content = load_content.join
      content.gsub!(/(\s*VERSION\s*=\s*)('|").*('|")/, "\\1\\2#{data.tag}\\3")
	    File.open(file_name, 'w' ) {|out| out.print content}
	    self
      content
    end

  end

end

