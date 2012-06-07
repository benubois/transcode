require 'boot'
include Transcode
require 'minitest/spec'
require 'minitest/autorun'

def scan
  if File.exist?(File.dirname(__FILE__) + '/data/scan.txt')
    IO.read(File.dirname(__FILE__) + '/data/scan.txt')
  else
    ''
  end
end
