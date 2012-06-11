module Transcode
  class Job
    
    def self.prepare_titles(disc_name = nil, id = nil, title = nil)
      if disc_name
        # Get disc info
        disc = Disc.new
        disc_info = disc.info(disc_name)
        titles = disc.title_candidates(disc_info['titles'])
        
        unless titles.empty?
          History.add(disc_name, disc_info)
        end
      else
        disc_info = History.get(id)
        titles = [title.to_i]
      end
      
      titles_to_transcode = []
      
      titles.each do |title|
        args = {
          'name'          => disc_info['name'],
          'path'          => disc_info['path'],
          'title'         => title,
          'original_name' => disc_info['name']
        }

        if titles.length > 1
          args['name'] += ".#{title.to_s}"
        end
        titles_to_transcode.push(args)
        
      end
      
      return titles_to_transcode
      
    end
    
    def self.convert_enqueue(titles_to_transcode)
      titles_to_transcode.each do |title|
        Resque.enqueue(ConvertJob, title)
        History.update_title_prop(title['original_name'], title['title'], 'queued', true)
        Transcode.log.info("Queued #{title.inspect} for encode")
      end
    end
    
    def self.enqueue_scan(name)
      Transcode.log.info("Queued #{name} for scan")
      Resque.enqueue(ScanJob, name)
    end
    
  end
end