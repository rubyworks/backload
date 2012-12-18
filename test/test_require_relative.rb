require File.expand_path('helper', File.dirname(__FILE__))

require 'loaded/require_relative'  # optional feature

class RequiredTestCase < MicroTest::TestCase

  def test_require_relative
    require_relative 'fixtures/example_relative'

    assert_equal 'fixtures/example_relative', $load_name

    assert $load_opts[:require]
    assert $load_opts[:relative]
    refute $load_opts[:load]
    refute $load_opts[:wrap]
  end

end

