require 'rake'

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'boot'

use Rack::ShowExceptions

run Rack::URLMap.new ({
	"/" => Resque::Server.new,
	"/manual" => Transcode::App.new,
})
