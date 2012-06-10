module Transcode
  class History
    
    def self.list
      keys    = $redis.keys("#{Transcode.config.redis_namespace}disc:*")
      
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
    
    def self.add(disc, titles)
      disc = update_title_prop(disc, titles, 'queued', true)
      disc['id'] = get_id(disc['name'])
      update_disc(disc['id'], disc)
    end
    
    def self.get_id(name)
      Transcode.config.redis_namespace + 'disc:' + Digest::SHA1.hexdigest(name)
    end
    
    def self.delete(id)
      $redis.del(id)
    end
    
    def self.set_progress_file(progress_file, args)
      id = get_id(args['original_name'])
      disc = get(id)
      disc = update_title_prop(disc, args['title'], 'progress_file', progress_file)
      update_disc(id, disc)
    end
    
    def self.set_progress(id, title, progress)
      disc = get(id)
      disc = update_title_prop(disc, title, 'progress', progress)
      update_disc(id, disc)
    end
    
    def self.update_disc(id, disc)
      $redis.set(id, disc.to_json)
    end
    
    def self.update_title_prop(disc, titles, property, value)
    	titles = [titles] unless titles.kind_of?(Array)
	
      disc['titles'].each_with_index do |disc_title, index|
        if titles.include?(disc_title['title'])
          disc['titles'][index][property] = value
        end
      end
      disc
    end
    
  end
end
