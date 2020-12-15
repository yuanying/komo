require 'erb'

# Render text via ERB using the built in ERB library.
Komo::Filters.register :erb do |input, renderer|
  b = renderer.get_binding
  ERB.new(input, nil, '-').result(b)
end

# EOF
