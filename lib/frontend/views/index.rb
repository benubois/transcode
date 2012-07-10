module Transcode
  module Views
    class Index < Layout
      
      def queue
        titles = []
        queued_titles = Resque.peek('transcode_convert', 0, Resque.size('transcode_convert'))
        queued_titles.each do |title|
          title = Title.find(title['args'][0])
          disc = Disc.find(title.disc_id)
          titles << {'name' => disc.name, 'title' => title.title}
        end
        titles
      end
      
    end
  end
end