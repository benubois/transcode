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

def seed
	disc = Transcode::Disc.new
	
	info = {}
	info['name'] = 'DVD Name'
	info['path'] = "#{Transcode.config.rips}/#{info['name']}"
	info['titles'] = disc.title_scan(scan)
	
	Transcode::History.add(info, [1])
end

def purge
  puts 'purge'
	keys    = $redis.keys("transcode*")
	keys.each { |key| Transcode::History.delete(key) }
end