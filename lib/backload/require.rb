module Kernel

  #
  # We create a noop method  b/c it simplifes implementation.
  # Just override this method to use.
  #
  def self.required(path)
  end

private

  #
  # Alias original Kernel#require method.
  #
  alias_method :require_without_callback, :require

  #
  # Redefine Kernel#require with callback.
  #
  def require(feature, options=nil)
    result = require_without_callback(feature)

    if result
      Kernel.required(feature)
      Kernel.backloaded(feature, :require=>true, :load=>false)
    end

    result
  end

  class << self
    #
    # Alias original Kernel.require method.
    #
    alias_method :require_without_callback, :require

    #
    # Redefine Kernel.require with callback.
    #
    def require(feature)
      result = require_without_callback(feature)

      if result
        Kernel.required(feature)
        Kernel.backloaded(feature, :require=>true, :load=>false)
      end

      result
    end
  end

end
