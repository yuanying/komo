require 'erb'
require 'time'

class Komo::Renderer
  include ERB::Util


  @@stack = []

  attr_reader :config
  attr_reader :page
  attr_reader :pages
  attr_reader :content

  def self.write( page )
    renderer = self.new(page)

    dest = page.destination
    FileUtils.mkdir_p ::File.dirname(dest)

    open(dest, 'w') do |io|
      renderer._render_page
      io.write(renderer.content)
    end
  end

  def initialize(page)
    unless page.instance_of? ::Komo::Resources::Page
      raise ArgumentError, "only page resources can be rendered '#{page.path}'"
    end

    @page = page
    @config = Komo::Resources.config
    @pages = Komo::Resources.pages
    @content = nil

    @_bindings = []
  end

  def render( *args )
    opts = Hash === args.last ? args.pop : {}
    resource = args.first
    resource = _find_partial(opts[:partial]) if resource.nil?

    str = case resource
      when ::Komo::Resources::Page
        ::Komo::Renderer.new(resource)._render_content
      # when Resources::Partial
      #   _render_partial(resource, opts)
      when ::Komo::Resources::Static
        resource._read
      else
        raise ::Komo::Error, "expecting a page or a partial but got '#{resource.class.name}'"
      end

    str
  end

  def _render_content
    _track_rendering(@page.path) {
      ::Komo::Filters.process(self, @page, @page._read)
    }
  end

  def _render_page
    @content = _render_content
    return @content unless @page.layout
    layout = ::Komo::Resources.find_layout(@page.layout)
    return @content if layout.nil?

    _track_rendering(layout.path) {
      @content = ::Komo::Filters.process(self, layout, layout._read)
    }
  end

  # call-seq:
  #    _track_rendering( path ) {block}
  #
  # Keep track of the page rendering for the given _path_. The _block_ is
  # where the the page will be rendered.
  #
  # This method keeps a stack of the current pages being rendeered. It looks
  # for duplicates in the stack -- an indication of a rendering loop. When a
  # rendering loop is detected, an error is raised.
  #
  # This method returns whatever is returned from the _block_.
  #
  def _track_rendering( path )
    loop_error = @@stack.include? path
    @@stack << path
    @_bindings << _binding

    if loop_error
      msg = "rendering loop detected for '#{path}'\n"
      msg << "    current rendering stack\n\t"
      msg << @@stack.join("\n\t")
      raise ::Komo::Error, msg
    end

    yield
  ensure
    @@stack.pop if path == @@stack.last
    @_bindings.pop
  end

  # call-seq:
  #    get_binding    => binding
  #
  # Returns the current binding for the renderer.
  #
  def get_binding
    @_bindings.last
  end

  # Returns the binding in the scope of this Renderer object.
  #
  def _binding() binding end

  # default helpers

  def url_for( *args )
    opts = Hash === args.last ? args.pop : {}
    obj = args.first

    anchor = opts.delete(:anchor)
    escape = opts.has_key?(:escape) ? opts.delete(:escape) : true

    url = obj.respond_to?(:url) ? obj.url : obj.to_s
    url = escape_once(url) if escape
    url = url.sub(/\.html$/, '')# if Webby.site.environment == 'production'
    url << "#" << anchor if anchor

    return url
  end

  def date_for page
    if page.posted_at
      page.posted_at
    elsif page.updated_at
      page.updated_at
    else
      page.mtime
    end
  end

  def abstract content, length=251
    content.gsub(/<.+?>|\n|\r/mu, '').split(//u)[0, length].join
  end

  # Returns an escaped version of +html+ without affecting existing escaped
  # entities.
  #
  # ==== Examples
  #   escape_once("1 > 2 &amp; 3")
  #   # => "1 &lt; 2 &amp; 3"
  #
  #   escape_once("&lt;&lt; Accept & Checkout")
  #   # => "&lt;&lt; Accept &amp; Checkout"
  #
  def escape_once( html )
    html.to_s.gsub(/[\"><]|&(?!([a-zA-Z]+|(#\d+));)/) { |special| ERB::Util::HTML_ESCAPE[special] }
  end
end
