module Transcode
  class Watch
    
    def self.start
      puts "Monitoring #{Transcode.config.rip_directory}"
      Listen.to(Transcode.config.rip_directory) do |modified, added, removed|
        puts  modified.inspect
        puts  added.inspect
        puts  removed.inspect
      end
    end
    
  end
end
