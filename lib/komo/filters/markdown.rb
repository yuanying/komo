# encoding: utf-8

require "rdiscount"
require "komo/filters"

Komo::Filters.register :markdown do |input|
  RDiscount.new(input).to_html
end

