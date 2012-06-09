module Transcode
  class ScanJob
    
    @queue = :transcode_scan

    def self.perform(disc_name)
      titles = Job.prepare_titles(disc_name)
      Job.convert_enqueue(titles)
    end
    
  end
end
