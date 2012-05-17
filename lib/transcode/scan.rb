module Transcode
  class Scan
    @queue = :transcode_scan

    def self.perform(rip_path)
      rip_path.force_encoding('UTF-8')
      hb = Handbrake.new
      hb.scan(rip_path)
    end
    
  end
end
