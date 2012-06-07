require File.expand_path("../helper", __FILE__)

describe Disc do
  before do
    @disc = Transcode::Disc.new
    @scan = scan
  end
  
  it "has titles" do
    scan = @disc.title_scan(@scan)
    scan.wont_be_empty
  end

end