module Kernel
  protected

  #
  # We create a noop method for loaded b/c it simplifes
  # implementation. Just override this method to use.
  #
  def self.loaded(path, options={})
  end
end

require 'loaded/load'
require 'loaded/require'
#require 'loaded/require_relative'

