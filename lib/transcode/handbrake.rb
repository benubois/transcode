module Transcode
  class Handbrake
    
    def self.convert(args)
      progress_file = Tempfile.new("transcode")
      
      History.update_title_prop(args['original_name'], args['title'], 'progress_file', progress_file.path)
      
      output = "#{Transcode.config.exports}/#{args['name']}.m4v"
      
      base = "#{Transcode.config.handbrake} -i #{Shellwords.escape(args['path'])} -o #{Shellwords.escape(output)} -t #{args['title']} -e x264 -q 20.0 -a 1,1 -E faac,copy:ac3 -B 160,160 -6 stereo,auto -R Auto,Auto -D 2.0,0.0 -f mp4 -4 --detelecine --decomb --loose-anamorphic -m -x b-adapt=2:rc-lookahead=50 --native-language eng --subtitle scan --subtitle-forced=1"
      
      # Do the conversion
      `#{base} 2>&1 > #{progress_file.path}`
      
      # Mark as transcoded
      History.update_title_prop(args['original_name'], args['title'], 'transcoded', true)
      
      progress_file.close
      progress_file.unlink
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
