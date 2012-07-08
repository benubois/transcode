module Transcode
  class Disc
    
    # Public: Returns the String id stored in the database
    attr_reader :id

    # Public: Returns the String name of the disc title
    attr_reader :name

    # Public: Returns the String path to the disc
    attr_reader :path

    # Public: Returns an Array of titles
    attr_accessor :titles
    
    def initialize(options)
      @id     = options['id']
      @name   = options['name']
      @path   = options['path'] 
      @titles = options['titles'] 
    end
    
    def self.find(id)
      disc = $redis.hgetall(id)
      disc = Disc.new(disc)
      disc.titles = Title.find_all("#{disc.id}:titles")
      disc
    end
    
    def self.new_from_rip(base, name, info)
      disc_path = "#{base}/#{name}"
      disc = {}
      disc['id'] = self.get_id(disc_path)
      disc['path'] = disc_path
      disc['name'] = name
      disc['titles'] = Title.get_titles_from_string(disc['id'], info)
      disc = Disc.new(disc)
      disc.auto_transcode
      disc
    end
    
    def self.get_id(disc_path)
        'transcode:disc:' + File.readlines("#{disc_path}/VIDEO_TS/discident.xml").grep(/fingerPrint/).to_s.match(/<fingerPrint>(.*?)<\/fingerPrint>/)[1]
    end
    
    def save
      $redis.multi
      
      # Add disc to disc set
      $redis.sadd('transcode:discs', @id)
      
      # Add disc hash
      $redis.mapped_hmset(@id, { 'id' => @id, 'name' => @name, 'path' => @path })

      # Add title set and hashes
      @titles.each do |title|
        title.save
      end
      
      $redis.exec
    end
    
    def delete
      # Get title set
      titles = $redis.smembers("#{@id}:titles")
      
      # Get blocks set
      blocks = $redis.smembers("#{@id}:blocks")
      
      $redis.multi

      # remove from set
      $redis.srem('transcode:discs', @id)
      
      # remove disc hash
      $redis.del(@id)
      
      # Remove title set
      $redis.del("#{@id}:titles")
      
      # Remove block set
      $redis.del("#{@id}:blocks")
      
      # Remove all titles
      $redis.del(titles)

      # Remove all blocks
      $redis.del(blocks)

      # Remove from filesystem
      # FileUtils.rm_rf(disc['path'])
      
      $redis.exec
      
    end
    
    def auto_transcode
      # remove anything under 20 min
      
      @titles.map do |title| 
        title.auto_transcode = false if title.duration < 1200
      end
      
      @titles.map do |title|
        blocks = @titles.inject([]) do |other_blocks, title_inner|
          unless title.blocks == title_inner.blocks
            other_blocks += title_inner.blocks
          end
          other_blocks.uniq.sort
        end
        
        # If a title cotains all the same blocks of every other title it's probably a play all title
        if blocks == title.blocks.sort
          title.auto_transcode = false
        end
      end
      
      @titles.map do |title|
        title.auto_transcode = true unless false == title.auto_transcode
      end
      
    end    
    
  end
end
