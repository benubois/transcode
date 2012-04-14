module Transcode
  def self.config
    OpenStruct.new \
      :rips      => File.expand_path(yaml['rips']),
      :exports   => File.expand_path(yaml['exports']),
      :handbrake => yaml['handbrake']
  end

  def self.yaml
    if File.exist?('config/transcode.yml')
      @yaml ||= YAML.load_file('config/transcode.yml')
    else
      {}
    end
  end
  
end
