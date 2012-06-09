module Transcode
  class Disc
    
    def info(name)
      disc = {}
      disc['name'] = name
      disc['path'] = "#{Transcode.config.rips}/#{name}"
      titles = utf8_clean(`#{Transcode.config.handbrake} -i #{Shellwords.escape(disc['path'])} -t 0 2>&1`)
      disc['titles'] = title_scan(titles)
      disc
    end
    
    def utf8_clean(data)
      ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
      ic.iconv(data + ' ')[0..-2]
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

    def title_scan(disc)

      # split by title and 
      titles = disc.split(/^\+ title /m)

      # remove non-title data
      titles.shift
  
      titles.map { |title|
        timecode = title.match(/\+ duration: (.*)/)[1]
        {
          'title'    => title.match(/^([0-9]+):/)[1].to_i,
          'duration' => timecode_to_seconds(timecode),
          'timecode' => timecode,
          'feature'  => title.include?('Main Feature'),
          'queued'   => false,
          'blocks'   =>   title.scan(/([0-9]+) blocks,/).flatten.map{|block| block.to_i }
        }
      }
    end

    def title_candidates(titles)
      # remove anything under 20 min
      title = titles.delete_if { |title| title['duration'] < 1200 }
  
      titles = titles.sort_by { |title| title['duration'] }.reverse
  
      if 1 === titles.length
        titles = titles
      else
        # Probably a tv show, titles that contain all the same blocks as any of the other titles
        # These titles are usually the "Play All" titles
        titles = titles.delete_if.each_with_index {|candidate, index| 
          title_contains_blocks(candidate, titles, index)
        }
      end  
      
      # Just return the title numbers
      titles.sort_by { |title| title['title'] }.map { |title| title['title'] }
    end
    
    def title_contains_blocks(candidate, titles, index)
      test_group = titles.dup
      test_group.delete_at(index)
      test_group.each do |title|
        return true if true === title['blocks'].all?{|block| candidate['blocks'].include?(block)}
      end
  
      return false
    end
    
    def self.delete(id)
      disc = History.get(id)
      # Remove from filesystem
      FileUtils.rm_rf(disc['path'])
      
      # Remove from history
      History.delete(id)
    end

  end
end