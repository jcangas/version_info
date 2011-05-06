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
end

