module Transcode
  class Scan
    @queue = :transcode_scan

    def self.perform(rip_path)
      Handbrake.scan(rip_path)
    end
    
  end
end
