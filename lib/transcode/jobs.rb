module Transcode
  class Jobs
    
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
  
  class ConvertJob
    @queue = :transcode_convert
    def self.perform(args)
      Disc.convert(args)
    end
  end
  
  class DeleteJob
    @queue = :transcode_delete
    def self.perform(id)
      Disc.delete(id)
    end
  end
  
  class ScanJob
    @queue = :transcode_scan
    def self.perform(base, name)
      info = Handbrake.scan("#{base}/#{name}")
      disc = Disc.new_from_rip(base, name, info)
      disc.save
      pp disc
    end
  end
  
end