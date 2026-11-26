# Print every load as it starts, to standard error, indented by how deep
# it is, so the output reads as a tree of what required what.
#
#   $ ruby -rbackload/trace script.rb
#
#   require json
#     require json/common
#       require json/version
#   require_relative lib/thing
#
# A feature that was already loaded is still listed, as it was asked for.
require 'backload'

def Kernel.backloading(feature, options={})
  word = options[:load] ? 'load' : (options[:relative] ? 'require_relative' : 'require')
  $stderr.puts "#{'  ' * options[:depth]}#{word} #{feature}"
end
