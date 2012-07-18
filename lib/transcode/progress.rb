module Transcode
  module Progress
    
    def receive_data(data)
      progress = data.match(/2 of 2, ([0-9]+.[0-9])/)
      if progress
        update_clients(progress[1])
        update_data(progress[1])
      end
    end
    
    def update_data(progress)
      $redis.hset($redis['transcode:transcoding'], 'progress', progress)
    end
    
    def update_clients(progress)
      if progress > $redis.hget($redis['transcode:transcoding'], 'progress')
        Pusher['progress_updates'].trigger!('progress', {:id => $redis['transcode:transcoding'], :progress => progress})
      end
    end
    
  end
end
