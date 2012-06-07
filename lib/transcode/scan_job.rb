module Transcode
  class ScanJob
    @queue = :transcode_scan

    def self.perform(rip_path)
      disc = Disc.new
      info = disc.info(rip_path)
      titles_to_convert = disc.title_candidates(info['titles'])

      # Enqueue Possible titles
      Job.convert_enqueue(titles_to_convert, info)
      
      # Add to scan to archive
      History.add(info, titles_to_convert)
    end
    
  end
end
