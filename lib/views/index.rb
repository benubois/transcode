module Transcode
  module Views
    class Index < Layout
      
      def queue
        Resque.peek('transcode_convert', 0, Resque.size('transcode_convert'))
      end
      
    end
  end
end