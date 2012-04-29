module Transcode
  class Scan
    @queue = :transcode_scan

    def self.perform(rip_path)
      hb = Handbrake.new
      hb.scan(rip_path)
    end
    
  end
end
