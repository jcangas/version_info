module VersionInfo
  class Tasks
    def self.install(opts = nil)
      dir = caller.find{|c| /Rakefile:/}[/^(.*?)\/Rakefile:/, 1]
      self.new(dir, opts && opts[:name]).install
    end
    
    def install
      namespace :vinfo do
        desc "bump SEGMENT , Bumps a version info segment ('major','minor','patch','state','build')"
        task 'bump' do
          puts "Wow!"
        end
      end
    end

  end
end
