module Transcode
  class Job
    
    def self.convert_enqueue(titles, disc)
      
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
        
        Resque.enqueue(ConvertJob, args)
      end
      
    end
    
    def self.enqueue_scan(name)
      Transcode.log.info("Queued #{name} for scan")
      Resque.enqueue(ScanJob, name)
    end
    
  end
end