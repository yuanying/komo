
# Render text via markdown using the RDiscount library.
require 'rdiscount'

Komo::Filters.register :markdown do |input|
  RDiscount.new(input).to_html
end

# EOF
