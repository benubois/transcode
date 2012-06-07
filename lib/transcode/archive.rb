# require 'rubygems'
# require 'redis'
# require 'json'
# $redis = Redis.connect(:url => 'redis://127.0.0.1', :thread_safe => true)

module Transcode
  class Archive
    
    def self.list
      list = get_list
    end
    
    def self.get_list
      keys    = $redis.keys("transcode:disc:*")

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
          # Remove from redis
          $redis.del(key)
          
          # remove from scans
          discs.delete(key)
        end
      end
      
      discs
      
    end
    
    def self.get(id)
      JSON.parse($redis.get(id))
    end
    
  end
end
