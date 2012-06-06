require 'rake'

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'boot'
require 'sprockets'

stylesheets = Sprockets::Environment.new
stylesheets.append_path ''

javascripts = Sprockets::Environment.new
javascripts.append_path ''

use Rack::ShowExceptions


map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'app/frontend/scripts'
  environment.append_path 'app/frontend/styles'
  run environment
end

map '/' do
  run Resque::Server.new
end

map '/manual' do
  run Transcode::App.new
end
