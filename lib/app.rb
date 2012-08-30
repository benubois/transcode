module Transcode
  class App < Sinatra::Base
    
    register Mustache::Sinatra
    require 'frontend/views/layout'
    
    dir = File.dirname(File.expand_path(__FILE__))

    set :public_folder, "#{dir}/frontend/public"
    set :static, true
    set :mustache, {
      :namespace => Transcode,
      :templates => "#{dir}/frontend/templates",
      :views => "#{dir}/frontend/views"
    }
    
    helpers do
      def pjax?
        env['HTTP_X_PJAX'] || false
      end
    end
    
    get '/' do
      @queue_selected = true
      mustache :index, :layout => !pjax?
    end
    
    get '/history' do
      @history_selected = true
      mustache :history, :layout => !pjax?
    end
    
    get '/enqueue/:title_id' do |title_id|
      Jobs.convert_enqueue(Title.find(title_id))
      content_type :json
      { :success => true }.to_json
    end
    
    get '/unqueue/:title_id' do |title_id|
      $redis.hset(title_id, 'queued', 'false')
      $redis.lrem('resque:queue:transcode_convert', 1, '{"class":"Transcode::ConvertJob","args":["' + title_id + '"]}')
      content_type :json
      { :success => true }.to_json
    end
    
    delete '/disc/:id' do |id|
      Resque.enqueue(DeleteJob, id)
      content_type :json
      { :success => true }.to_json
    end
    
  end
end