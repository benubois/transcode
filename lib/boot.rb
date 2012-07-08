# encoding: UTF-8
$stdout.sync = true

require 'rubygems'
require 'bundler'
Bundler.setup

require 'fileutils'
require 'shellwords'
require 'logger'
require 'digest/sha1'
require 'iconv'
require 'tempfile'

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
require 'transcode/progress'
require 'transcode/disc'
require 'transcode/jobs'
require 'transcode/watch'
require 'transcode/history'
require 'app'

include FileUtils

$redis = Redis.connect(:url => 'redis://127.0.0.1', :thread_safe => true)
