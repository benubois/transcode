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
    
    post '/enqueue' do
      disc = History.get(params[:id])
      title = params[:title].to_i
      History.delete(params[:id])
      History.add(disc, [title])
      # Job.convert_enqueue(title, disc)
    end
    
  end
end