# encoding: UTF-8
module Transcode
  class Handbrake
    
    def scan(name)
      full_path = "#{Transcode.config.rips}/#{name}"
      info      = `#{Transcode.config.handbrake} -i #{Shellwords.escape(full_path)} -t 0 2>&1`
      
      titles = title_scan(info)
      titles = extract_titles(titles)
      
      Transcode.log.info("Extracted #{titles.inspect}")
      
      titles.each do |title|
        
        args = {
          'path'  => full_path,
          'name'  => name,
          'title' => title[:title]
        }
        
        if titles.length > 1
          args['name'] += ".#{title[:title]}"
        end
        
        Transcode.log.info("Queued #{args.inspect} for encode")
        
        Resque.enqueue(Convert, args)
      end
      
    end
    
    def self.convert(args)
      
      output = "#{Transcode.config.exports}/#{args['name']}.m4v"
      
      base = "#{Transcode.config.handbrake} -i #{Shellwords.escape(args['path'])} -o #{Shellwords.escape(output)} -t #{args['title']} -e x264 -q 20.0 -a 1,1 -E faac,copy:ac3 -B 160,160 -6 stereo,auto -R Auto,Auto -D 2.0,0.0 -f mp4 -4 --detelecine --decomb --loose-anamorphic -m -x b-adapt=2:rc-lookahead=50 --native-language eng --subtitle scan --subtitle-forced=1"
      
      # Do the conversion
      `#{base} 2>&1`
    end
    
    def timecode_to_seconds(timecode)
      multipliers = [1, 60, 3600]
      seconds = timecode.split(':').map { |time| time.to_i * multipliers.pop }
      seconds.inject {|sum, n| sum + n }
    end

    def title_scan(info)
      # split by title and 
      titles = info.split(/^\+ title /m)

      # remove non-title data
      titles.shift
  
      titles.map { |title|
        {
          :title    => title.match(/^([0-9]+):/)[1].to_i,
          :duration => timecode_to_seconds(title.match(/\+ duration: (.*)/)[1]),
          :feature  => title.include?('Main Feature'),
          :blocks => title.scan(/([0-9]+) blocks,/).flatten.map{|block| block.to_i }
        }
      }
    end

    def extract_titles(titles)
      # remove anything under 20 min
      title = titles.delete_if { |title| title[:duration] < 1200 }
  
      titles = titles.sort_by { |title| title[:duration] }.reverse
  
      if 1 === titles.length
        titles = titles
      elsif 2 === titles.length
        titles = titles.keep_if { |title| title[:feature] }
      else
        # Probably a tv show, titles that contain all the same blocks as any of the other titles
        # These titles are usually the "Play All" titles
        titles = titles.delete_if.each_with_index {|candidate, index| 
          title_contains_blocks(candidate, titles, index)
        }
      end  
      
        titles = titles.sort_by { |title| title[:title] }

      return titles
    end
    
    def title_contains_blocks(candidate, titles, index)
      test_group = titles.dup
      test_group.delete_at(index)
      test_group.each do |title|
        return true if true === title[:blocks].all?{|block| candidate[:blocks].include?(block)}
      end
  
      return false
    end

  end
end