require 'rake'

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'boot'
require 'sprockets'

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'lib/frontend/scripts'
  environment.append_path 'lib/frontend/styles'
  run environment
end

map '/resque' do
  run Resque::Server.new
end

map '/' do
  run Transcode::App.new
end
