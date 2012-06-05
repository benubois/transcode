require 'rubygems'
require 'redis'
require 'json'
$redis = Redis.connect(:url => 'redis://127.0.0.1', :thread_safe => true)

module Transcode
  class Archive
    
    def self.list
      list = get_list
    end
    
    def self.get_list
      keys    = $redis.keys("transcode:scan:*")

      if keys.empty?
        []
      else
        values  = $redis.mget(*keys)
        values = values.map { |value| JSON.parse(value) }
        list = Hash[*keys.zip(values).flatten]
        list = cleanup(list)
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
      
      scans
      
    end
    
  end
end

Transcode::Archive.list