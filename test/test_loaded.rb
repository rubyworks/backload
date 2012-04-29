require 'minitest/autorun'
require 'loaded'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/fixtures')

class RequiredTestCase < MiniTest::Unit::TestCase

  def Kernel.required(name, mod=nil)
    @@required = name
  end

  def Kernel.loaded(name, mod=nil)
    @@loaded = name
  end

  def test_required
    require 'example'
    assert_equal('example', @@required)
  end

  def test_load
    load 'example.rb'
    assert_equal('example.rb', @@loaded)
  end

end
