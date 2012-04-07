#!/usr/bin/env ruby
require 'fileutils'
require 'shellwords'
require 'pp'
include FileUtils

class Converter
  def initialize
    @job_queue = []
    @rip_directory = "/Users/bb/Movies"
    @export_directory = "/Users/bb/Desktop/Export"
    @handbrake = "HandBrakeCLI"
    @rips = get_rip_info
    
    queue_jobs
    
    puts @job_queue[0]
  end
  
  def get_rip_info
    rips = []
    Dir.chdir(@rip_directory)
    Dir.glob("*").map do |name|
      full_path = Shellwords.escape(File.expand_path(name))
      rips.push({
        :info => info(full_path),
        :name => name,
        :path => full_path
      })
    end
    return rips
  end
  
  def queue_jobs
    @rips.each do |rip|
      if rip[:info].include?("No title found")
        next
      elsif rip[:info].include?("Main Feature")
        @job_queue.push(encode(rip[:path], Shellwords.escape(rip[:name]), true))
      else
        titles = rip[:info].scan(/^\+ title ([\d]+):/)
        titles = titles.flatten
        titles.each do |title|
          @job_queue.push(encode(rip[:path], Shellwords.escape(rip[:name] + ".#{title}"), nil, title))
        end
      end
    end
  end
  
  def info(path)
    `#{@handbrake} -i #{path} -t 0 --min-duration 1200 2>&1`
  end
  
  def encode(input, output_file, feature = nil, title = nil)
    base = "#{@handbrake} -i #{input} -o #{@export_directory}/#{output_file}.m4v -e x264 -q 20.0 -a 1,1 -E faac,copy:ac3 -B 160,160 -6 stereo,auto -R Auto,Auto -D 2.0,0.0 -f mp4 -4 --detelecine --decomb --loose-anamorphic -m -x b-adapt=2:rc-lookahead=50 --native-language eng --subtitle scan --subtitle-forced=1"
    
    if feature.nil?
      base = base + " -t #{title}"
    else  
      base = base + " --main-feature"
    end
    
    return base + " 2>&1"
  end
  
end

convert = Converter.new
