
# If RedCloth is installed, then configure the textile filter
require 'redcloth'

Komo::Filters.register :textile do |input|
  RedCloth.new(input, %w(no_span_caps)).to_html
end

# EOF
