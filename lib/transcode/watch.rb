# encoding: UTF-8
module Transcode
  class Watch
    
    def start
      Transcode.log.info("Started watching #{Transcode.config.rips}")
      FSSM.monitor(Transcode.config.rips, '*', :directories => true) do |path|
        path.create do |base, name, type|
          if is_movie_candidate?(name, type)
            Job.enqueue_scan(name)
          end
        end
        path.update {|base, name, type|}
        path.delete {|base, name, type|}
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
    
  end
end
