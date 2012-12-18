module Kernel
  private

  #
  # Alias original Kernel#require_relative method.
  #
  alias_method :require_relative_without_callback, :require_relative

  #
  # Redefine Kernel#require_relative with callback.
  #
  # @todo It would nice if the `:relative` option were set to the
  #       realtive path, but that would require `Binding.of_caller`.
  #
  def require_relative(feature, options=nil)
    options = {:require => true, :relative => true}
    result  = require_relative_without_callback(feature)
    Kernel.loaded(feature, options) if result
    result
  end

  class << self
    private

    #
    # Alias original Kernel.require_relative method.
    #
    alias_method :require_relative_without_callback, :require_relative

    #
    # Redefine Kernel.require_relative with callback.
    #
    # @todo It would nice if the `:relative` option were set to the
    #       realtive path, but that would require `Binding.of_caller`.
    #
    def require_relative(feature, options=nil)
      options = {:require => true, :relative => true}
      result  = require_relative_without_callback(feature)
      Kernel.loaded(feature, options) if result
      result
    end
  end

end
