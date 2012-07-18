module Transcode
  class Handbrake
    
    def self.convert(title_id)
      title = Title.find(title_id)
      disc  = Disc.find(title.disc_id)
      
      # Save what title is currently being transcoded
      $redis.set('transcode:transcoding', title.id)
      
      output = "#{Transcode.config.exports}/#{disc.name}.#{title.title}.m4v"
      base   = "#{Transcode.config.handbrake} -i #{Shellwords.escape(disc.path)} -o #{Shellwords.escape(output)} -t #{title.title} -e x264 -q 20.0 -a 1,1 -E faac,copy:ac3 -B 160,160 -6 stereo,auto -R Auto,Auto -D 2.0,0.0 -f mp4 -4 --detelecine --decomb --loose-anamorphic -m -x b-adapt=2:rc-lookahead=50 --native-language eng --subtitle scan --subtitle-forced=1"
      
      ports = $redis.hgetall('transcode:progress:port')
      
      # Do the conversion and send progress to progress server
      `#{base} 2>&1 | nc #{ports['ip']} #{ports['port']}`
      
      # Nothing is transcoding now
      $redis.del('transcode:transcoding')
      
      # Mark as transcoded
      $redis.hset(title.id, 'transcoded', 'true')
    end
    
    def self.scan(path)
      utf8_clean(`HandBrakeCLI -i #{Shellwords.escape(path)} -t 0 2>&1`)
    end
    
    def self.utf8_clean(data)
      ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
      ic.iconv(data + ' ')[0..-2]
    end

  end
end
