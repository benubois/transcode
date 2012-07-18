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
  EventMachine::run {
    # Binding to port 0 gives us a system assigned port
    server = EM.start_server "0.0.0.0", 0, Transcode::Progress
    port = Socket.unpack_sockaddr_in(EM.get_sockname(server))
    $redis.mapped_hmset('transcode:progress:port', { 'port' => port[0], 'ip' => port[1] })
  }
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs.push 'lib'
  test.pattern = 'test/*_test.rb'
  test.verbose = true
end
