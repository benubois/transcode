require File.expand_path("../helper", __FILE__)

describe Disc do
  
  before do
    @name = 'DVD Name'
    @location = '/tmp/transcode'
    @progress_file = Tempfile.new("transcode")
  end
  
  after do
    @progress_file.close
    @progress_file.unlink
  end
  
  it "can create, read and delete itself" do
    Progress.set_location(@location, @name).must_equal('OK')
    
    Progress.get_location(@name).must_equal(@location)
    
    Progress.delete_location(@name).must_equal(1)
  end
  
  it "makes progress" do
    Progress.save_location(@progress_file, name)
  end

end