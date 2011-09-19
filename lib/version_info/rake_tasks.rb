module VersionInfo 
  class RakeTasks
    include Rake::DSL
    
    def self.install(opts = {})
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

        desc "Show version file name"
        task :file do
          puts "(#{VersionInfo.file_format.to_s})#{target::VERSION.file_name}"
        end

        desc "Show complete version info"
        task :inspect do
          puts target::VERSION.inspect
        end

        desc "Show tag. Create version file if none"
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

