module Transcode
  class Job
    
    def self.prepare_titles(disc_name = nil, id = nil, title = nil)
      if disc_name
        # Get disc info
        disc = Disc.new
        disc_info = disc.info(disc_name)
        titles = disc.title_candidates(disc_info['titles'])
      else
        disc_info = History.get(id)
        titles = [title.to_i]
        History.delete(id)
      end
      
      titles_to_transcode = []
      
      titles.each do |title|
        args = {
          'name'  => disc_info['name'],
          'path'  => disc_info['path'],
          'title' => title
        }

        if titles.length > 1
          args['name'] += ".#{title.to_s}"
        end
        
        titles_to_transcode.push(args)
        
      end
      
      return {
        'titles_to_transcode' => titles_to_transcode,
        'titles' => titles,
        'disc_info' => disc_info
      }
      
    end
    
    def self.convert_enqueue(prepared_titles)
      
      prepared_titles['titles_to_transcode'].each do |title|
        Resque.enqueue(ConvertJob, title)
        Transcode.log.info("Queued #{title.inspect} for encode")
      end
      
      # Add to scan to archive
      unless prepared_titles['titles'].empty?
        History.add(prepared_titles['disc_info'], prepared_titles['titles'])
      end
      
    end
    
    def self.enqueue_scan(name)
      Transcode.log.info("Queued #{name} for scan")
      Resque.enqueue(ScanJob, name)
    end
    
  end
end