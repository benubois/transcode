require File.expand_path("../helper", __FILE__)

describe Disc do
  before do
    seed
    @disc = Transcode::Disc.new
    @scan = scan
  end
  
  after do
    purge
  end
  
  it "has titles" do
    scan = @disc.title_scan(@scan)
    scan.wont_be_empty
  end

  it "can delete itself" do
    name = 'DVD Name'
    file = "#{Transcode.config.rips}/#{name}"
    FileUtils.mkdir(file)
    id = History.get_id(name)
    Disc.delete(id)
    File.exists?(file).must_equal false
  end

end