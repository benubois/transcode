require 'minitest/autorun'

class TestDisc < MiniTest::Unit::TestCase
  def setup
    @disc = Disc.new
  end
  
  def test_disc_has_titles
    @disc.info(rip_path)
    
    assert_equal 0, @register.total
  end
end