module Transcode
  module Progress
    
    def receive_data(data)
      progress = data.match(/2 of 2, (.*?)\./)
      if progress
        $redis.hset($redis['transcode:transcoding'], 'progress', progress[1])
      end
    end
    
  end
end
