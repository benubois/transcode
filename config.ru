require 'rubygems'
require 'bundler'
Bundler.setup

require 'logger'
require 'resque/server'

use Rack::ShowExceptions

Resque.redis.namespace = "resque:transcode"
run Rack::URLMap.new ({
  "/" => Resque::Server.new
})
