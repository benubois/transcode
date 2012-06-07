module Transcode
  module Views
    class Index < Layout
      
      def queue
        Transcode.log.info("Queued #{Resque.working.inspect} ")
        
        Resque.peek('transcode_convert', 0, Resque.size('transcode_convert'))
      end
      
    end
  end
end