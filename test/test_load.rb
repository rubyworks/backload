require File.expand_path('helper', File.dirname(__FILE__))

class RequiredTestCase < MicroTest::TestCase

  def test_load
    load 'example_load.rb'

    assert_equal 'example_load.rb', $load_name

    refute $load_opts[:require]
    refute $load_opts[:relative]
    assert $load_opts[:load]
    refute $load_opts[:wrap]
  end

end

