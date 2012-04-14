module Transcode
  class Convert
    include Resque::Plugins::Status
    
    @queue = :transcode_convert

    def perform
      Handbrake.convert(options['args'], status['uuid'])
    end
    
  end
end
