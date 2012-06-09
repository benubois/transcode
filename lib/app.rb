module Transcode
  class App < Sinatra::Base
    
    register Mustache::Sinatra
    require 'views/layout'
    
    dir = File.dirname(File.expand_path(__FILE__))

    set :public_folder, "#{dir}/frontend/public"
    set :static, true
    set :mustache, {
      :namespace => Transcode,
      :templates => "#{dir}/templates",
      :views => "#{dir}/views"
    }
    
    get '/' do
      mustache :index
    end
    
    get '/history' do
      mustache :history
    end
    
    post '/enqueue' do
      Job.convert_enqueue(nil, params[:id], params[:title].to_i)
      content_type :json
      { :success => true }.to_json
    end
    
    delete '/disc/:id' do |id|
      Disc.delete(id)
      content_type :json
      { :success => true }.to_json
    end
    
  end
end