module Transcode
  module Views
    class Index < Layout
      
      def queue
        titles = []
        titles << Title.find($redis['transcode:transcoding'])
        Resque.peek('transcode_convert', 0, Resque.size('transcode_convert')).each do |title|
          titles << Title.find(title['args'][0])
        end
        titles
      end
      
    end
  end
end