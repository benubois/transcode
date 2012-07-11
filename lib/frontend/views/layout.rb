module Transcode
  module Views
    class Layout < Mustache
      
      def queue_selected
        @queue_selected || false
      end
      
      def history_selected
        @history_selected || false
      end
      
      def title 
        @title || "Transcode"
      end
      
    end
  end
end