# encoding: utf-8

require "komo/filters"
require 'komo/filters/markdown'
require 'komo/filters/erb'

module Komo
  class PolymorphicFilter < Filter
    def call(resource, content, options={})
      if filter = resource.metadata.filter
        filter = [filter] if filter.kind_of?(String)
        filter.each do |f|
          case f
          when 'markdown'
            content = MarkdownFilter.call(resource, content, options)
          when 'erb'
            content = ErbFilter.call(resource, content, options)
          else
            raise "Unknown Filter: #{f}"
          end
        end
      end
      content
    end
  end
end

