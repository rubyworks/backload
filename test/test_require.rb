require File.expand_path('helper', File.dirname(__FILE__))

class RequiredTestCase < MicroTest::TestCase

  def test_require
    require 'example_require'

    assert_equal 'example_require', $load_name

    assert $load_opts[:require]
    refute $load_opts[:relative]
    refute $load_opts[:load]
    refute $load_opts[:wrap]
  end

end

