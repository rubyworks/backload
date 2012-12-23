module Kernel
  
  #
  # We create a noop method b/c it simplifes implementation.
  # Just override this method to use.
  #
  def self.loaded(path, wrap=nil)
  end

private

  #
  # Alias original Kernel#load method.
  #
  alias_method :load_without_callback, :load

  #
  # Redefine Kernel#load with callback.
  #
  def load(path, wrap=nil)
    result = load_without_callback(path, wrap)

    if result
      Kernel.loaded(path, wrap)
      Kernel.backloaded(path, :load=>true, :require=>false, :wrap=>wrap)
    end

    result
  end

  class << self
    #
    # Alias original Kernel.load method.
    #
    alias_method :load_without_callback, :load

    #
    # Redefine Kernel.load with callback.
    #
    def load(path, wrap=nil)
      result = load_without_callback(path, wrap)

      if result
        Kernel.loaded(path, wrap)
        Kernel.backloaded(path, :load=>true, :require=>false, :wrap=>wrap)
      end

      result
    end
  end

end
