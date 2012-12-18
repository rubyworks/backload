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
    options = {:require => true, :relative => true, :load => false}

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

    Kernel.loaded(feature, options) if result

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
      options = {:require => true, :relative => true, :load => false}

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

      Kernel.loaded(feature, options) if result

      result
    end
  end

end
