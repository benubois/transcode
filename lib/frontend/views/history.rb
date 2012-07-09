module Transcode
  module Views
    class History < Layout
      
      def discs
        Transcode::History.list
      end
      
    end
  end
end