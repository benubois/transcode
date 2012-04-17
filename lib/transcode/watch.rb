module Transcode
  class Watch
    
    def start
      FSSM.monitor(Transcode.config.rips, '*', :directories => true) do |path|
        path.create do |base, relative, type|
          if is_movie_candidate?(relative, type)
            enqueue_scan(relative)
          end
        end
        path.update {|base, relative, type|}
        path.delete {|base, relative, type|}
      end
    end
    
    def is_movie_candidate?(name, type)
      
      if name.include?('.ripit')
        return false
      end
      
      if 'file' === type.to_s
        return false
      end
      
      true
    end
    
    def enqueue_scan(name)
      puts "Queueing #{name}"
      Resque.enqueue(Scan, name)
    end
    
  end
end
