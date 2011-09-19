module VersionInfo
  module ThorTasks
    def self.install(opts = {})
      Class.new(::Thor) do
        @target = opts[:target]
        class << self
            attr_reader :target
        end
        namespace :vinfo

        desc 'file, '"Show version file format & name"
        def file
          puts "#{VersionInfo.file_format.to_s} format: #{target::VERSION.file_name}"
        end

        desc 'show', "Show tag. Create version file if none"
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

