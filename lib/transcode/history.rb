module Transcode
  class History
    
    def self.list
      keys    = $redis.keys("#{Transcode.config.redis_namespace}disc:*")
      
      if keys.empty?
        []
      else
        discs = $redis.mget(*keys)
        discs = discs.map { |disc| JSON.parse(disc) }
        cleanup(discs)
      end
    end
    
    def self.cleanup(discs)

      discs.reject do |disc|
        
        if File.exists? disc['path']
          false
        else
          delete(disc['id'])
          true
        end
      end
      
    end
    
    def self.get(id)
      JSON.parse($redis.get(id))
    end
    
    def self.add(name, disc)
      disc['id'] = get_id(name)
      update_disc(disc['id'], disc)
    end
    
    def self.get_id(name)
      Transcode.config.redis_namespace + 'disc:' + Digest::SHA1.hexdigest(name)
    end
    
    def self.delete(id)
      $redis.del(id)
    end
        
    def self.update_disc(id, disc)
      $redis.set(id, disc.to_json)
    end
    
    def self.update_title_prop(name, titles, property, value)
      
      id = get_id(name)
      disc = get(id)
      
    	titles = [titles] unless titles.kind_of?(Array)
	
      disc['titles'].each_with_index do |disc_title, index|
        if titles.include?(disc_title['title'])
          disc['titles'][index][property] = value
        end
      end
      
      update_disc(id, disc)
    end
    
  end
end
