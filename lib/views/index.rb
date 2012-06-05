module Transcode
  module Views
    class Index < Layout
      
      def movies
        [
          {
            "path"   => "/Users/bb/Movies/A Movie", 
            "name"   => "A Movie", 
            "titles" => [{"title"=>1, "duration"=>2997, "feature"=>false, "blocks"=>[38547, 185494, 267415, 287751, 97471, 112126, 127829, 37225, 4]}, {"title"=>2, "duration"=>3389, "feature"=>false, "blocks"=>[39716, 151100, 171550, 177794, 267927, 140363, 355744, 44184, 4]}, {"title"=>3, "duration"=>3307, "feature"=>false, "blocks"=>[38542, 153650, 161623, 234624, 259135, 198478, 188046, 42403, 4]}]
          }
        ]
      end
      
    end
  end
end