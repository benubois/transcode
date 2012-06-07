# encoding: UTF-8
module Transcode
  class ConvertJob

    @queue = :transcode_convert

    def self.perform(args)
      Disc.convert(args)
    end
    
  end
end
