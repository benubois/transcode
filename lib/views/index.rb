module Transcode
  module Views
    class Index < Layout
      
      
      def movies
        Transcode::Archive.list
      end
      
    end
  end
end