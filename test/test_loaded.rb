require 'minitest/autorun'
require 'loaded'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/fixtures')

class RequiredTestCase < MiniTest::Unit::TestCase

  def Kernel.loaded(name, opts)
    if opts[:require]
      if opts[:relative]
        $relative = name
      else
        $required = name
      end
    else
      $loaded = name
    end
  end

  def test_load
    load 'example_load.rb'
    assert_equal('example_load.rb', $loaded)
  end

  def test_required
    require 'example_require'
    assert_equal('example_require', $required)
  end

  #def test_require_relative
  #  require_relative 'fixtures/example_relative'
  #  assert_equal('example_relative', $relative)
  #end

end

