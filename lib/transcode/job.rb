module Transcode
  class Job
    
    def self.convert_enqueue(disc_name = nil, id = nil, title = nil)
      
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
      
      titles.each do |title|
        args = {
          'name'  => disc_info['name'],
          'path'  => disc_info['path'],
          'title' => title
        }
        if titles.length > 1
          args['name'] += ".#{title['title']}"
        end
        
        Transcode.log.info("Queued #{args.inspect} for encode")
        
        Resque.enqueue(ConvertJob, args)
      end
      
      # Add to scan to archive
      unless titles.empty?
        History.add(disc_info, titles)
      end
      
    end
    
    def self.enqueue_scan(name)
      Transcode.log.info("Queued #{name} for scan")
      Resque.enqueue(ScanJob, name)
    end
    
  end
end