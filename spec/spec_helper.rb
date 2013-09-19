require 'coveralls'
Coveralls.wear!

require 'test_notifier/runner/rspec'
require 'version_info'

if Notifier.os?(/mingw32/)
	module Notifier
		module Growl
			def supported?
				return true
			end
			 def notify(options)
				command = [
					"growlnotify",
					"/a:test_notifier",
					"/i:" + options.fetch(:image, ''),
					"/p:2",
					"/silent:true",
					"/r:" + '"General Notification"',
					"/t:" + options[:title],
					options[:message]
				]
				system(*command)
			end

			def self.register
			end
		end
	end
end
