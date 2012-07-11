module Transcode
  module Views
    class Index < Layout
      
      def queue
        titles = []
        title = Title.find($redis['transcode:transcoding'])
        if title
          disc = Disc.find(title.disc_id)
          titles << {'name' => disc.name, 'title' => title.title, 'timecode' => title.timecode, 'progress' => title.progress, 'id' => title.id}
        end
        queued_titles = Resque.peek('transcode_convert', 0, Resque.size('transcode_convert'))
        queued_titles.each do |title|
          title = Title.find(title['args'][0])
          disc = Disc.find(title.disc_id)
          titles << {'name' => disc.name, 'title' => title.title, 'timecode' => title.timecode, 'progress' => title.progress, 'id' => title.id}
        end
        titles
      end
      
    end
  end
end