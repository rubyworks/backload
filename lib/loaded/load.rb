module Kernel
  private

  #
  # Alias original Kernel#load method.
  #
  alias_method :load_without_callback, :load

  #
  # Redefine Kernel#load with callback.
  #
  def load(feature, options=nil)
    if not Hash === options
      wrap = options
      options = {:wrap => wrap}
    end
    options[:require] = false

    result = load_without_callback(feature, options[:wrap])
    Kernel.loaded(feature, options) if result
    result
  end

  class << self
    private

    #
    # Alias original Kernel.load method.
    #
    alias_method :load_without_callback, :load

    #
    # Redefine Kernel.load with callback.
    #
    def load(feature, options=nil)
      if not Hash === options
        wrap = options
        options = {:wrap => wrap}
      end
      options[:require] = false

      result = load_without_callback(feature, options[:wrap])
      Kernel.loaded(feature, options) if result
      result
    end

  end

end
