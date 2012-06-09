module Transcode
  class DeleteJob
    
    @queue = :transcode_delete

    def self.perform(id)
      Disc.delete(id)
    end
    
  end
end
