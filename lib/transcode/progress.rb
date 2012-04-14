module Transcode
  class Progress
    include Resque::Plugins::Status

    def watch
      Dir.chdir('/tmp')
      while true
        sleep 5
        Dir.glob("*").each do |file|
          matches = file.scan(/^transcode-([a-fA-F0-9]{32})/)
          unless matches.empty?
            job_id = matches.flatten[0]
            update_progress(file, job_id)
          end
        end
      end
    end
    
    def update_progress(file, job_id)
      file = File.open("/tmp/#{file}", "r")
      contents = file.read
      file.close

      progress = contents.scan(/([0-9]+)\.[0-9]+ %/)
      progress = progress.flatten[0]
      
      puts job_id
      puts progress
      
      Resque::Plugins::Status::Hash.set(job_id, :total => 100, :num => progress, :status => 'working')
    end
    
  end
end
