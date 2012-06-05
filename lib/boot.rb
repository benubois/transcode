# encoding: UTF-8
$stdout.sync = true

require 'rubygems'
require 'bundler'
Bundler.setup

require 'fileutils'
require 'shellwords'
require 'logger'
require 'digest/sha1'

require 'json'
require 'redis'
require 'resque'
require 'resque/tasks'
require 'resque/server'
require 'rake'
require 'sinatra/base'
require 'fssm'

require 'transcode'
require 'transcode/handbrake'
require 'transcode/convert'
require 'transcode/scan'
require 'transcode/watch'
require 'transcode/archive'
require 'transcode/app'

include FileUtils

$redis = Redis.connect(:url => 'redis://127.0.0.1', :thread_safe => true)
