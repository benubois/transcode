module Transcode
  class Job
    
    def self.format_titles(disc_info, titles)
      titles.map { |title|
        name = (titles.length > 1)  ? "#{disc_info['name']}.#{title.to_s}" : disc_info['name']
        {
          'name'          => name,
          'path'          => disc_info['path'],
          'title'         => title,
          'original_name' => disc_info['name']
        }
      }
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