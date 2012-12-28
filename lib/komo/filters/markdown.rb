# encoding: utf-8

require "rdiscount"
require "komo/filters"

module Komo
  class MarkdownFilter < Filter
    def call(resource, content, options={})
      RDiscount.new(content).to_html
    end
  end
end
