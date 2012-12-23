module Kernel

  #
  # We create a noop method b/c it simplifes implementation.
  # Just override this method to use.
  #
  # Presently this is an optional feature and must be required 
  # separately via `backload/require_relative`.
  #
  def self.required_relative(path)
  end

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
    #result = require_relative_without_callback(feature)

    ## We have to reimplement #require_relative instead of calling
    ## the alias to ensure the proper path is used. (*sad*)
    result = (
      c = caller.first
      fail "Can't parse #{c}" unless c.rindex(/:\d+(:in `.*')?$/)
      file = $` # File.dirname(c)
      if /\A\((.*)\)/ =~ file # eval, etc.
        raise LoadError, "require_relative is called in #{$1}"
      end
      options[:relative] = File.dirname(file)
      absolute = File.expand_path(feature, File.dirname(file))
      require_without_callback(absolute)
    )

    if result
      Kernel.required_relative(feature)
      Kernel.backloaded(feature, :require=>true, :load=>false, :relative=>true)
    end

    result
  end

  class << self
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
      #result = require_relative_without_callback(feature)

      ## We have to reimplement #require_relative instead of calling
      ## the alias to ensure the proper path is used. (*sad*)
      result = (
        c = caller.first
        fail "Can't parse #{c}" unless c.rindex(/:\d+(:in `.*')?$/)
        file = $` # File.dirname(c)
        if /\A\((.*)\)/ =~ file # eval, etc.
          raise LoadError, "require_relative is called in #{$1}"
        end
        options[:relative] = File.dirname(file)
        absolute = File.expand_path(feature, File.dirname(file))
        require_without_callback absolute
      )

      if result
        Kernel.required_relative(feature)
        Kernel.backloaded(feature, :require=>true, :load=>false, :relative=>true)
      end

      result
    end
  end

end
