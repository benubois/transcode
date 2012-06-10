module Transcode
  class Progress
    
    def self.watch
      while true
        sleep 5
        check_status
      end
    end
    
    def self.check_status
      discs = get_discs
      discs.each do |disc|
        disc['titles'].each do |title|
          if File.exists? title['progress_file']
            Transcode.log.info("progress disc: #{disc.inspect}")
            progress = read_progress(title['progress_file'])
            History.set_progress(disc['id'], title['title'], progress)
          end
        end
      end
    end
    
    def self.get_discs
      keys = $redis.keys("#{Transcode.config.redis_namespace}disc:*")
      if keys.empty?
        []
      else
        discs = $redis.mget(*keys)
        discs.map { |disc| JSON.parse(disc) }
      end
    end
    
    def self.read_progress(location)
      file = File.open(location, "r")
      contents = file.read
      file.close

      progress = contents.scan(/2 of 2, (.*?)\./)
      if progress.empty?
    	  0
      else	
    	  progress.last[0].to_i
      end
    end
    
  end
end
