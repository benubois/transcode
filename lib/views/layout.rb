module Transcode
  module Views
    class Layout < Mustache
      
      def title 
        @title || "Transcode"
      end
      
    end
  end
end