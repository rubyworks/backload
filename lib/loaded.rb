module Kernel
  private

  #
  # Alias original Kernel#require method.
  #
  alias_method :require_without_callback, :require

  #
  # Redefine Kernel#require with callback.
  #
  def require(feature, mod=nil)
    result = require_without_callback(feature)

    callback = Kernel.method(:required) rescue nil

    if callback && result
      if callback.arity == 1
        callback.call(feature)
      else
        callback.call(feature, mod)
      end
    end

    return result
  end

  #
  # Alias original Kernel#load method.
  #
  alias_method :load_without_callback, :load

  #
  # Redefine Kernel#load with callback.
  #
  def load(feature, mod=nil)
    flag = Hash === mod ? mod[:scope] : mod

    result = load_without_callback(feature, flag)

    callback = Kernel.method(:loaded) rescue nil

    if callback && result
      if callback.arity == 1
        callback.call(feature)
      else
        callback.call(feature, mod)
      end
    end

    return result
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
    def require(feature, mod=nil)
      result = require_without_callback(feature)

      callback = Kernel.method(:required) rescue nil

      if callback && result
        if callback.arity == 1
          callback.call(feature)
        else
          callback.call(feature, mod)
        end
      end

      return result
    end

    #
    # Alias original Kernel.load method.
    #
    alias_method :load_without_callback, :load

    #
    # Redefine Kernel.load with callback.
    #
    def load(feature, mod=nil)
      flag = Hash === mod ? mod[:scope] : mod

      result = load_without_callback(feature, flag)

      callback = Kernel.method(:loaded) rescue nil

      if callback && result
        if callback.arity == 1
          callback.call(feature)
        else
          callback.call(feature, mod)
        end
      end

      return result
    end

  end

end
