module Kernel
  private

  #
  # Alias original Kernel#require method.
  #
  alias_method :require_without_callback, :require

  #
  # Redefine Kernel#require with callback.
  #
  def require(feature, options=nil)
    options = {:require => true}
    result = require_without_callback(feature)
    Kernel.loaded(feature, options) if result
    result
  end

  class << self
    private

    #
    # Alias original Kernel.require method.
    #
    alias_method :require_without_callback, :require

    #
    # Redefine Kernel.require with callback.
    #
    def require(feature, options=nil)
      options = {:require => true}
      result  = require_without_callback(feature)
      Kernel.loaded(feature, options) if result
      result
    end
  end

end
