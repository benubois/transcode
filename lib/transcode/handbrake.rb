module Transcode
  class Handbrake
    
    def scan(name)
      disc = {}
      disc['name'] = name
      disc['path'] = "#{Transcode.config.rips}/#{name}"
      disc['titles'] = title_scan(`#{Transcode.config.handbrake} -i #{Shellwords.escape(disc['path'])} -t 0 2>&1`)
      
      # Enqueue Possible titles
      titles_to_convert = title_candidates(disc['titles'])
      convert_enqueue(titles_to_convert, disc)
      
      # Add to scan to archive
      archive(disc, titles_to_convert)
    end
    
    def archive(disc, titles_to_convert)
      disc = mark_as_queued(disc, titles_to_convert)
      disc['id'] = "transcode:disc:#{Digest::SHA1.hexdigest(disc['name'])}"
      $redis.set disc['id'], disc.to_json
    end
    
    def mark_as_queued(disc, titles_to_convert)
      disc['titles'].each_with_index do |title, index|
        if titles_to_convert.include?(title['title'])
          disc['titles'][index]['queued'] = true
        end
      end
      disc
    end
    
    def convert_enqueue(titles, disc)
      Transcode.log.info("Extracted #{titles.inspect}")
      
      unless titles.kind_of?(Array)
        titles = [titles]
      end
      
      titles.each do |title|
        args = {
          'name'  => disc['name'],
          'path'  => disc['path'],
          'title' => title
        }
        if titles.length > 1
          args['name'] += ".#{title['title']}"
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

  end
end