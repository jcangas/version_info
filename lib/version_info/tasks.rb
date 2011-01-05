module VersionInfo
  class Tasks
    def self.install(opts = nil)
      #dir = caller.find{|c| /Rakefile:/}[/^(.*?)\/Rakefile:/, 1]
      dir = File.dirname(Rake.application.rakefile_location)
      self.new(dir).install
    end
    
    attr_reader :root_path

    def initialize(root_path)
      @root_path = root_path
    end

    def install
      namespace :vinfo do
        desc "Show current version tag and create version_info.yml if missing"
        task :show do
          puts VERSION.tag
          VERSION.save unless File.exist?(VERSION.class.file_name)
        end
        
        VersionInfo.segments.each do |sgm|
          desc "Bumps version segment #{sgm.to_s.upcase}"
          task sgm.to_sym do
            VERSION.bump(sgm)
            puts "version changed to #{VERSION.tag}"
            VERSION.save
          end
        end
      end
    end
  end
end
