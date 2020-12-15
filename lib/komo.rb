require 'logging'
require "komo/version"

module Komo
  class Error < StandardError; end
  # Your code goes here...

  def self.init( config )
    @config = config
    Komo::Resources.init(config)
  end

  def self.config
    @config
  end

  def self.cairn
    @cairn ||= ::File.join(config.output_dir, '.cairn')
  end
end

require 'komo/core_ext/hash'
require 'komo/core_ext/enumerable'
require 'komo/config'
require 'komo/resources'
require 'komo/filters'
require 'komo/filters/erb'
require 'komo/filters/markdown'
require 'komo/filters/textile'
require 'komo/journal'
require 'komo/renderer'
require 'komo/builder'
