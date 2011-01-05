module VersionInfo
  class Tasks
    def self.install(opts = {})
      #dir = caller.find{|c| /Rakefile:/}[/^(.*?)\/Rakefile:/, 1]
      dir = File.dirname(Rake.application.rakefile_location)
      self.new(dir, opts).install
    end
    
    attr_reader :root_path
    attr_reader :target

    def initialize(root_path, opts)
      @root_path = root_path
      @target = opts[:class]
    end

    def install
      namespace :vinfo do

        desc "Inspect all current version keys"
        task :inspect do
          puts target::VERSION.inspect
        end

        desc "Show current version tag and create version_info.yml if missing"
        task :show do
          puts target::VERSION.tag
          target::VERSION.save unless File.exist?(target::VERSION.file_name)
        end
        
        VersionInfo.segments.each do |sgm|
          desc "Bumps version segment #{sgm.to_s.upcase}"
          task sgm.to_sym do
            target::VERSION.bump(sgm)
            puts "version changed to #{target::VERSION}"
            target::VERSION.save
          end
        end
      end
    end
  end
end
