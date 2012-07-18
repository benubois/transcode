module Transcode
  module Views
    class Index < Layout
      
      def queue
        titles = []
        
        # Get current job
        unless $redis['transcode:transcoding'].nil?
          titles << Title.find($redis['transcode:transcoding'])
        end
        
        Resque.peek('transcode_convert', 0, Resque.size('transcode_convert')).each do |title|
          if 'args' == title[0]
            titles << Title.find(title[1][0])
          elsif title.respond_to?(:has_key?) && title.has_key?('args')
            titles << Title.find(title['args'][0])
          end
        end
        
        titles
      end
      
    end
  end
end