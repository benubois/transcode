module Transcode
  module Views
    class Index < Layout
      
      def movies
        History.list
      end
      
    end
  end
end