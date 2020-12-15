module Komo::Filters

  class << self

    # Register a handler for a filter
    def register( filter, &block )
      _handlers[filter.to_s] = block
    end

    # Process input through filters
    def process( renderer, page, input )
      if page.filter.respond_to? :each
        page.filter.each do |f|
          f = Komo::Filters[f]
          input = f.call(input, renderer) if f
        end
      else
        f = Komo::Filters[page.filter]
        input = f.call(input, renderer) if f
      end
      return input
    end

    # Access a filter handler
    def []( name )
      _handlers[name]
    end

    # The registered filter handlers
    def _handlers
      @handlers ||= {}
    end

  end

end
