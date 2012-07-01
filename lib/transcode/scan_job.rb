module Transcode
  class ScanJob
    
    @queue = :transcode_scan

    def self.perform(disc_name)
      # Get disc info
      disc = Disc.new
      disc_info = disc.info(disc_name)

      titles = Job.format_titles(disc_info, disc.title_candidates(disc_info['titles']))
      
      unless titles.empty?
        History.add(disc_name, disc_info)
        Job.convert_enqueue(titles)
      end
      
    end
    
  end
end
