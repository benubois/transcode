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
      
      def enqueue(title_id)
        Jobs.convert_enqueue(Title.find(title_id))
      end
      
      def unqueue(title_id)
        $redis.hset(title_id, 'queued', 'false')
        $redis.lrem('resque:queue:transcode_convert', 1, '{"class":"Transcode::ConvertJob","args":["' + title_id + '"]}')
      end
      
      def success
        content_type :json
        { :success => true }.to_json
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
    
    get '/unqueue/:title_id' do |title_id|
      unqueue(title_id)
      success
    end
    
    get '/toggle_queued/:title_id' do |title_id|
      if 'true' == $redis.hget(title_id, 'queued')
        unqueue(title_id)
      else
        enqueue(title_id)
      end
      success
    end
    
    delete '/disc/:disc_id' do |disc_id|
      Resque.enqueue(DeleteJob, disc_id)
      success
    end
    
  end
end