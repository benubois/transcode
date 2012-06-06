# encoding: UTF-8
module Transcode
  class ConvertJob

    @queue = :transcode_convert

    def self.perform(args)
      Handbrake.convert(args)
    end
    
  end
end
