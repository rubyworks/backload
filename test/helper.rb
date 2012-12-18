# Load our test framework.
require 'microtest'
require 'microtest/assertions'

# Load the library to be tested.
require 'loaded'

# Put our load fixtures on the load path.
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/fixtures')

# We use this setup to test each possible load configuration.
def Kernel.loaded(name, opts)
  $load_name = name
  $load_opts = opts
end

# Old version of Microtest lacks #refute.
module MicroTest::Assertions
  unless method_defined?(:refute)
    def refute(fact, msg=nil)
      __assert__(!fact, msg)
    end
  end
end

