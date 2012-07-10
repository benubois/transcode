module Transcode
  module Views
    class History < Layout
      
      def discs
        Disc.find_all('transcode:discs')
      end
      
    end
  end
end