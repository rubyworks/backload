require 'assay/ae'
require 'rbconfig'
require 'backload'

# Put our load fixtures on the load path.
$LOAD_PATH.unshift(File.expand_path('fixtures', __dir__))

FIXTURES = File.expand_path('fixtures', __dir__)

# Record every callback: [which, feature, options or other arguments].
$calls = []

def Kernel.backloading(feature, options={})
  $calls << [:backloading, feature, options]
end

def Kernel.backloaded(feature, options={})
  $calls << [:backloaded, feature, options]
end

def Kernel.required(feature)
  $calls << [:required, feature]
end

def Kernel.loaded(path, wrap=nil)
  $calls << [:loaded, path, wrap]
end

def Kernel.required_relative(feature, directory=nil)
  $calls << [:required_relative, feature, directory]
end

module Spectrum::World

  # The callbacks made during a block, less those for features that
  # aren't fixtures (an assertion may load something of its own).
  def calls
    $calls.clear
    yield
    $calls.dup.select{ |c| c[1].to_s =~ /example|nest|sibling|auto_thing/ }
  end

end
