require 'backload/version'

# Backload gives Ruby's loading methods callbacks.
#
# To use it, define any of these methods of Kernel (none of them exists
# until you do):
#
#   Kernel.backloading(feature, options)   # before a load or require
#   Kernel.backloaded(feature, options)    # after one that loaded something
#
# The options say what happened:
#
#   :require   true for #require and #require_relative
#   :load      true for #load
#   :relative  for #require_relative, the directory it is relative to
#   :wrap      for #load, its second argument
#   :depth     how many loads this one is inside of (0 at the top)
#
# There are also plain callbacks for each method, called after it:
# Kernel.required(feature), Kernel.loaded(path, wrap) and
# Kernel.required_relative(feature, directory).
#
# The "after" callbacks are called only when something was loaded: not
# when #require returns false because the feature was loaded before, and
# not when it raises. The "before" callback is called every time.
#
module Backload

  # The methods put in front of Kernel's own.
  HOOKS = proc do

    #
    def require(feature)
      Backload.around(feature, :require=>true, :load=>false) do
        super
      end
    end

    #
    def load(path, wrap=false)
      Backload.around(path, :load=>true, :require=>false, :wrap=>wrap) do
        super
      end
    end

    # Ruby's #require_relative works out the directory from the file that
    # called it, so it can't be called from here on that file's behalf.
    # Instead the directory is found here and the feature required by
    # its full path, which is what #require_relative does.
    def require_relative(feature)
      feature = feature.to_path if feature.respond_to?(:to_path)
      location = caller_locations(1, 1).first
      base = location && (location.absolute_path || location.path)
      if base.nil? || !File.file?(base)
        raise LoadError, "cannot infer basepath"
      end
      dir  = File.dirname(File.realpath(base))
      path = File.expand_path(feature, dir)
      Backload.around(feature, :require=>true, :load=>false, :relative=>dir) do
        Backload.without_callbacks{ require(path) }
      end
    end

  end

  # The hooks for Kernel's module methods, which are public.
  module Hooks
    module_eval(&HOOKS)
  end

  # The hooks for Kernel's instance methods, which are private.
  module PrivateHooks
    module_eval(&HOOKS)
    private :require, :load, :require_relative
  end

  # Run a load between the callbacks. The block does the loading.
  def self.around(feature, options)
    # A load made on another's behalf (see #without_callbacks) is passed
    # over, once: the loads made inside it are reported as usual.
    if Thread.current[:backload_off]
      Thread.current[:backload_off] = false
      return yield
    end

    depth   = (Thread.current[:backload_depth] ||= 0)
    options = options.merge(:depth=>depth)

    Kernel.backloading(feature, options) if Kernel.respond_to?(:backloading)

    Thread.current[:backload_depth] = depth + 1
    begin
      result = yield
    ensure
      Thread.current[:backload_depth] = depth
    end

    if result
      if options[:load]
        Kernel.loaded(feature, options[:wrap]) if Kernel.respond_to?(:loaded)
      elsif options[:relative]
        if Kernel.respond_to?(:required_relative)
          if Kernel.method(:required_relative).arity == 1
            Kernel.required_relative(feature)
          else
            Kernel.required_relative(feature, options[:relative])
          end
        end
      else
        Kernel.required(feature) if Kernel.respond_to?(:required)
      end
      Kernel.backloaded(feature, options) if Kernel.respond_to?(:backloaded)
    end

    result
  end

  # Run a block in which the outermost load isn't reported. Loads made
  # by the file being loaded are.
  def self.without_callbacks
    old = Thread.current[:backload_off]
    Thread.current[:backload_off] = true
    yield
  ensure
    Thread.current[:backload_off] = old
  end

end

module Kernel
  prepend Backload::PrivateHooks

  class << self
    prepend Backload::Hooks
  end
end
