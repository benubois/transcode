# encoding: UTF-8
module Transcode
  class Convert

    @queue = :transcode_convert

    def self.perform(args)
      Handbrake.convert(args)
    end
    
  end
end
