require File.expand_path("../helper", __FILE__)

describe Disc do
  before do
    ResqueSpec.reset!
    purge
  end
  
  after do
    purge
  end
  
  it "scans" do
      scan = ScanJob.new
      scan.perform('/Users/ben/Movies', 'Hotel')
  end

end