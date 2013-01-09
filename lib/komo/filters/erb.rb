# encoding: utf-8

require 'erb'
require "komo/filters"

# Render text via ERB using the built in ERB library.
Komo::Filters.register :erb do |input, cursor|
  b = cursor.renderer.get_binding
  ERB.new(input, nil, '-').result(b)
end

# EOF
