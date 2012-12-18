#require 'minitest/autorun'
require 'microtest'
require 'microtest/assertions'
require 'loaded'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/fixtures')

# We use this setup to test each possible load configuration.

def Kernel.loaded(name, opts)
  $load_name = name
  $load_opts = opts
end

