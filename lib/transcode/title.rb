module Transcode
  class Title
    
    # Public: Returns the String id stored in the database
    attr_reader :id
    
    # Public: Returns the Integer number of the title
    attr_reader :title
    
    # Public: Returns the Integer length of the title
    attr_reader :duration
    
    # Public: Returns the String length of title in HH:MM:SS
    attr_reader :timecode
    
    # Public: Returns the Boolean value of whether or not handbrake thinks this 
    # is the feature
    attr_reader :feature
    
    # Public: Returns the Boolean value of whether or not this has been queued
    attr_reader :queued
    
    # Public: Returns the Boolean value of whether or this has been 
    # successfully transcoded
    attr_reader :transcoded
    
    # Public: Returns the String value of the location of the progress file
    attr_reader :progress_file
    
    # Public: Returns the Interger value of the percentage completeness of the 
    # transcode
    attr_reader :progress
    
    # Public: Returns an array of blocks belonging to this title
    attr_accessor :blocks
    
    # Public: Returns a bool of whether or not this title was marked to auto transcode
    attr_accessor :auto_transcode
    
    def initialize(options)
      @id             = options['id']
      @title          = options['title']
      @duration       = options['duration']
      @timecode       = options['timecode']
      @feature        = options['feature']
      @queued         = options['queued']
      @transcoded     = options['transcoded']
      @progress_file  = options['progress_file']
      @progress       = options['progress']
      @blocks         = options['blocks']
      @auto_transcode = options['auto_transcode']
    end
    
    # Instantiate new title instance from database
    def self.find(id)
      Title.new($redis.hgetall(id))
    end
    
    def self.find_all(set_id)
      titles = []
      $redis.smembers(set_id).each do |title|
        titles.push(Title.find(title))
      end
      titles
    end
    
    def self.initialize_from_string(disc_id, title)
      options = {}
      options['title']          = title.match(/^([0-9]+):/)[1].to_i
      options['timecode']       = title.match(/\+ duration: (.*)/)[1]
      options['duration']       = timecode_to_seconds(options['timecode'])
      options['feature']        = title.include?('Main Feature')
      options['queued']         = false
      options['transcoded']     = false
      options['progress_file']  = ''
      options['progress']       = 0
      options['blocks']         = title.scan(/([0-9]+) blocks,/).flatten.map{|block| block.to_i }
      options['id']             = "#{disc_id}:title:#{options['title']}"
      options['auto_transcode'] = nil
      Title.new(options)
    end
    
    def self.get_titles_from_string(disc_id, info)
      # split by title and remove first
      info.split(/^\+ title /m)[1..-1].map { |title| initialize_from_string(disc_id, title) }
    end
    
    def self.timecode_to_seconds(timecode)
      multipliers = [1, 60, 3600]
      seconds = timecode.split(':').map { |time| time.to_i * multipliers.pop }
      seconds.inject {|sum, n| sum + n }
    end
    
    def to_a
  	  hash = {}
  	  self.instance_variables.each {|var| hash[var.to_s.delete("@")] = self.instance_variable_get(var) }
      hash.delete('blocks')
  	  hash
    end

  end
end
