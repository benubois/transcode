module Transcode
  def self.config
    OpenStruct.new \
      :rip_directory    => yaml['rip_directory'],
      :export_directory => yaml['export_directory'],
      :handbrake        => yaml['handbrake']
  end

  def self.yaml
    if File.exist?('config/transcode.yml')
      @yaml ||= YAML.load_file('config/transcode.yml')
    else
      {}
    end
  end
  
end
