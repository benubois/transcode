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
require 'coffee-script'
require 'sass'
require 'redis'
require 'resque'
require 'resque/tasks'
require 'resque/server'
require 'rake'
require 'sinatra/base'
require 'mustache/sinatra'
require 'fssm'

require 'transcode'
require 'transcode/disc'
require 'transcode/job'
require 'transcode/convert_job'
require 'transcode/scan_job'
require 'transcode/delete_job'
require 'transcode/watch'
require 'transcode/history'
require 'app'

include FileUtils

$redis = Redis.connect(:url => 'redis://127.0.0.1', :thread_safe => true)
