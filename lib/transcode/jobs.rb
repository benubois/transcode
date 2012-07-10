module Transcode
  class Jobs
        
    def self.convert_enqueue(objekt)
      case objekt.class.name
      when 'Transcode::Disc'
        objekt.titles.map do |title| 
          if title.auto_transcode?
            Resque.enqueue(ConvertJob, title.id)
            title.queued = true
          end
        end
        objekt.save
      when 'Transcode::Title'
        Resque.enqueue(ConvertJob, objekt.id)
        objekt.queued = true
        objekt.save
      end
    end
    
    def self.enqueue_scan(base, name)
      Transcode.log.info("Queued #{name} for scan")
      Resque.enqueue(ScanJob, base, name)
    end
    
  end
  
  class ConvertJob
    @queue = :transcode_convert
    def self.perform(title_id)
      Handbrake.convert(title_id)
    end
  end
  
  class DeleteJob
    @queue = :transcode_delete
    def self.perform(id)
      disc = Disc.find(id)
      disc.delete()
    end
  end
  
  class ScanJob
    @queue = :transcode_scan
    def self.perform(base, name)
      info = Handbrake.scan("#{base}/#{name}")
      disc = Disc.new_from_rip(base, name, info)
      disc.save
      Jobs.convert_enqueue(disc)
    end
  end
  
end