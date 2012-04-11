# -*- encoding: utf-8 -*-
require File.expand_path('../lib/transcode/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ben Ubois"]
  gem.email         = ["ben@benubois.com"]
  gem.description   = %q{Transcode DVDs to M4Vs.}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "transcode"
  gem.require_paths = ["lib"]
  gem.version       = Transcode::VERSION
  
  gem.add_dependency "sinatra"
  gem.add_dependency "resque"
  
end
