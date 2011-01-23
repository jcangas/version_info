module VersionInfo
  module ThorTasks
    def self.install(opts = {})
      Class.new(::Thor) do
        @target = opts[:class]
        class << self
            attr_reader :target
        end
        namespace :vinfo

        desc 'show', "Show version tag and create version_info.yml if missing"
        def show
          puts target::VERSION.tag
          target::VERSION.save unless File.exist?(target::VERSION.file_name)
        end

        desc "inspect", "Show complete version info"
        def inspect
          puts target::VERSION.inspect
        end

        desc "bump SEGMENT=patch", "bumps segment: [#{VersionInfo.segments.join(', ')}]"
        def bump(sgm = :patch)
            target::VERSION.bump(sgm)
            puts "version changed to #{target::VERSION}"
            target::VERSION.save
        end

      protected
        def target
            self.class.target
        end
      end
    end
  end
  
  class RakeTasks
    
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

        desc "Show complete version info"
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

