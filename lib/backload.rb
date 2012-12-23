require 'backload/load'
require 'backload/require'
#require 'backload/require_relative'

module Kernel

  # Common callback for all loading methods: #load, #require
  # and #require_relative.
  #
  # @param [Hash] options
  #   The load callback options.
  #
  # @option options [Boolean] :load
  #   True if #load was used.
  #
  # @option options [Boolean] :require
  #   True is #require or #require_relative was used.
  #
  # @option options [Boolean] :relative
  #   True is #require_relative was used.
  #
  # @option options [Boolean] :wrap
  #   The wrap argument passed to #load.
  #
  def self.backloaded(path, options={})
  end

end

