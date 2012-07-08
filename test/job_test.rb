require File.expand_path("../helper", __FILE__)

describe Disc do
  before do
    seed
    @scan = scan
  end
  
  after do
    purge
  end
  
  it "has prepared titles" do
    titles = Jobs.prepare_titles(nil, History.get_id('DVD Name'), 1)
    titles['titles_to_transcode'].length.must_equal 1
  end

end