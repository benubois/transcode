require 'rubygems'
require 'redis'
require 'json'
$redis = Redis.connect(:url => 'redis://127.0.0.1', :thread_safe => true)

module Transcode
  class Archive
    
    def self.list
      list = get_list
      puts list.to_s
    end
    
    def self.get_list
      keys    = $redis.keys("transcode:scan:*")
      
      if keys
        values  = $redis.mget(*keys)
        values = values.map { |value| JSON.parse(value) }
        list = Hash[*keys.zip(values).flatten]
        list = cleanup(list)
      else
        []
      end
    end
    
    def self.cleanup(scans)
      scans.each do |key, scan|
        unless File.exists? scan['path']
          # Remove from redis
          $redis.del(key)
          
          # remove from scans
          scans.delete(key)
        end
        
      end
    end
    
    def self.add
      $redis.set "transcode:scan:2", 'test2'
    end
    
  end
end

Transcode::Archive.list