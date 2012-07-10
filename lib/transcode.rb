# encoding: UTF-8
module Transcode
  
  def self.log
    @log ||= Logger.new(File.expand_path(File.dirname(File.dirname(__FILE__))) + '/log/transcode.log')
  end
  
  def self.config
    OpenStruct.new({
      :rips            => File.expand_path(yaml['rips']),
      :exports         => File.expand_path(yaml['exports']),
      :handbrake       => yaml['handbrake'],
      :pusher_app_id   => yaml['pusher_app_id'],
      :pusher_key      => yaml['pusher_key'],
      :pusher_secret   => yaml['pusher_secret'],
      :redis_namespace => 'transcode:'
    })
  end

  def self.yaml
    if File.exist?('config/transcode.yml')
      @yaml ||= YAML.load_file('config/transcode.yml')
    else
      {}
    end
  end
  
  def self.to_bool(value)
    return true if value == true || value == 'true'
    return false if value == false || value.empty? || self == 'false'
  end
  
end