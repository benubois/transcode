require 'rubygems'
require 'rake'
require 'yaml'

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'boot'

desc "Start the server"
task :start do
  Kernel.exec "bundle exec foreman start"
end

desc "Start the directory watch process"
task :watch do
  watch = Transcode::Watch.new
  watch.start
end

desc "Start the progress reporter"
task :progress do
  progress = Transcode::Progress.new(nil)
  progress.watch
end

desc "Add dummy data to redis"
task :seed do
	disc = Transcode::Disc.new
	scan = IO.read(File.dirname(__FILE__) + '/test/data/scan.txt')
	
  info = {}
  info['name'] = 'DVD Name'
  info['path'] = "#{Transcode.config.rips}/#{info['name']}"
  info['titles'] = disc.title_scan(scan)
	
	Transcode::History.add(info, [1])
end

desc "Remove dummy data from redis"
task :purge do
  keys    = $redis.keys("transcode*")
	keys.each { |key| Transcode::History.delete(key) }
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs.push 'lib'
  test.pattern = 'test/*_test.rb'
  test.verbose = true
end
