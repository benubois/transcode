$stdout.sync = true

require 'rubygems'
require 'bundler'
Bundler.setup

require 'fileutils'
require 'shellwords'
require 'tempfile'

require 'fssm'
require 'resque-status'
require 'resque'
require 'resque/tasks'

require 'transcode'
require 'transcode/handbrake'
require 'transcode/convert'
require 'transcode/scan'
require 'transcode/watch'
require 'transcode/progress'

include FileUtils
