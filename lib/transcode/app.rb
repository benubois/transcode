module Transcode
  class App < Sinatra::Base
    
    get '/' do
      Archive.list
    end
    
  end
end