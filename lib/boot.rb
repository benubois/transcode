$stdout.sync = true

require 'rubygems'
require 'bundler'
Bundler.setup

require 'listen'
require 'resque/tasks'

require 'transcode'
require 'transcode/watch'