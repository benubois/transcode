require 'boot'
include Transcode
require 'minitest/spec'
require 'minitest/autorun'
require 'resque_spec'

def purge
  keys = $redis.keys("transcode*")
  $redis.delete(keys)
end