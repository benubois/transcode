module Transcode
  class History
    
    def self.list
      keys    = $redis.keys("#{Transcode.config.redis_namespace}*")
      
      if keys.empty?
        []
      else
        values  = $redis.mget(*keys)
        values = values.map { |value| JSON.parse(value) }
        discs = Hash[*keys.zip(values).flatten]
        discs = cleanup(discs)
        discs.values
      end
    end
    
    def self.cleanup(discs)
      discs.each do |key, disc|
        
        unless File.exists? disc['path']
          
          unless disc['name'] == 'DVD Name'
            # Remove from redis
            delete(key)
          
            # remove from scans
            discs.delete(key)
          end

        end
      end
      discs
    end
    
    def self.get(id)
      JSON.parse($redis.get(id))
    end
    
    def self.add(disc, titles_to_convert)
      disc = mark_as_queued(disc, titles_to_convert)
      disc['id'] = get_id(disc['name'])
      $redis.set disc['id'], disc.to_json
    end
    
    def self.get_id(name)
      Transcode.config.redis_namespace + Digest::SHA1.hexdigest(name)
    end
    
    def self.delete(id)
      $redis.del(id)
    end
    
    def self.mark_as_queued(disc, titles_to_convert)
      disc['titles'].each_with_index do |title, index|
        if titles_to_convert.include?(title['title'])
          disc['titles'][index]['queued'] = true
        end
      end
      disc
    end
    
  end
end
