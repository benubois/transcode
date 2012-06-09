module Transcode
  class ScanJob
    
    @queue = :transcode_scan

    def self.perform(disc_name)
      Job.convert_enqueue(disc_name)
    end
    
  end
end
