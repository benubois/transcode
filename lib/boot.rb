$stdout.sync = true

require 'rubygems'
require 'bundler'
Bundler.setup

require 'fssm'
require 'resque/tasks'
require 'fileutils'

require 'transcode'
require 'transcode/scan'

include FileUtils
