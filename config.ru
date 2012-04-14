require 'rubygems'
require 'bundler'
Bundler.setup

require 'logger'
require 'resque/server'

use Rack::ShowExceptions

run Rack::URLMap.new ({
  "/" => Resque::Server.new
})
