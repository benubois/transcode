module Transcode
  class Scan
    @queue = :transcode_scan

    def self.perform(rip_path)
      Transcode.log.info(rip_path.encoding)
      hb = Handbrake.new
      hb.scan(rip_path)
    end
    
  end
end
