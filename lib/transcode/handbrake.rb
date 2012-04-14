module Transcode
  class Handbrake
    
    def self.scan(name)
      full_path = "#{Transcode.config.rips}/#{name}"
      info      = `#{Transcode.config.handbrake} -i #{Shellwords.escape(full_path)} -t 0 --min-duration 1200 2>&1`
      
      unless info.include?("No title found")
        if info.include?("Main Feature")
          args = {
            'path'    => full_path,
            'name'    => name,
            'feature' => true
          }
          job_id = Convert.create(:args => args)
        else
          titles = info.scan(/^\+ title ([\d]+):/)
          titles = titles.flatten
          titles.each do |title|
            args = {
              'path'  => full_path,
              'name'  => "#{name}.#{title}",
              'title' => title
            }
            Convert.create(:args => args)
          end
        end
      end
    end
    
    def self.convert(args, job_id)
      
      progress_file = Tempfile.new("transcode-#{job_id}", '/tmp')
      
      output = "#{Transcode.config.exports}/#{args['name']}.m4v"
      base = "#{Transcode.config.handbrake} -i #{Shellwords.escape(args['path'])} -o #{Shellwords.escape(output)} -e x264 -q 20.0 -a 1,1 -E faac,copy:ac3 -B 160,160 -6 stereo,auto -R Auto,Auto -D 2.0,0.0 -f mp4 -4 --detelecine --decomb --loose-anamorphic -m -x b-adapt=2:rc-lookahead=50 --native-language eng --subtitle scan --subtitle-forced=1"
    
      if args.has_key?('feature') && args['feature']
        base = "#{base} --main-feature"
      else  
        base = "#{base} -t #{args['title']}"
      end
      
      # Do the conversion
      `#{base} 2>&1 > #{progress_file.path}`
      
      progress_file.close
      progress_file.unlink
    end
    
  end
end