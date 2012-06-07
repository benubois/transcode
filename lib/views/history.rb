module Transcode
  module Views
    class History < Layout
      
      def movies
        Transcode::History.list
      end
      
    end
  end
end