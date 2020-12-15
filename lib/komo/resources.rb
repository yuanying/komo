module Komo::Resources

  class << self
    attr_reader :config

    # Returns the pages hash object.
    #
    def pages
      @pages ||= ::Komo::Resources::DB.new
    end

    # Returns the layouts hash object.
    #
    def layouts
      @layouts ||= ::Komo::Resources::DB.new
    end

    def init( config )
      @config = config

      ::Find.find(config.layout_dir) do |path|
        next unless test ?f, path
        # next if path =~ ::Komo.exclude
        self.register_layout(path)
      end

      ::Find.find(config.content_dir) do |path|
        next unless test ?f, path
        # next if path =~ ::Komo.exclude
        self.register_page(path)
      end

      # self.pages.each do |r|
      #   # if r.filter.respond_to? :each
      #   #   r.filter.each do |f|
      #   #     filters << f if f
      #   #   end
      #   # else
      #   #   filters << r.filter if r.filter
      #   # end
      #   # if r.kind_of?(Page) && r.type == 'entry'
      #   #   puts ::Komo::Renderer.new(r).render_content
      #   # end
      #   # if r.kind_of?(Static)
      #   #   puts r.destination
      #   # end
      # end
    end

    def register_layout( fn )
      self.register( fn ) do | mf |
        return unless mf.meta_data?

        mf.each do |meta_data|
          r = ::Komo::Resources::Layout.new(fn)
          self.layouts << r
        end
      end
    end

    def register_page( fn )
      self.register( fn ) do | mf |
        # see if we are dealing with a static resource
        unless mf.meta_data?
          r = ::Komo::Resources::Static.new(fn)
          self.pages << r
          return r
        end

        # this is a renderable page
        mf.each do |meta_data|
          r = ::Komo::Resources::Page.new(fn, meta_data)
          self.pages << r
          r
        end
      end
    end

    def register( fn )
      begin
        fd = ::File.open(fn, 'r')
        mf = MetaFile.new fd

        yield mf

      rescue MetaFile::Error => err
        logger.error "error loading file #{fn.inspect}"
        logger.error err
      ensure
        fd.close if fd
      end
    end

    # Returns the directory component of the _filename_ with the content
    # directory removed from the beginning if it is present.
    #
    def dirname( filename )
      rgxp = %r/\A(?:#{self.config.content_dir}|#{self.config.layout_dir})\/?/o
      dirname = ::File.dirname(filename)
      dirname << '/' if dirname.index(?/) == nil
      dirname.sub(rgxp, '')
    end

    # Returns the last component of the _filename_ with any extension
    # information removed.
    #
    def basename( filename )
      ::File.basename(filename, '.*')
    end

    # Returns the extension (the portion of file name in path after the
    # period). This method excludes the period from the extension name.
    #
    def extname( filename )
      ::File.extname(filename).tr('.', '')
    end

    # Returns the layout resource corresponding to the given _filename_ or
    # +nil+ if no layout exists under that filename.
    #
    def find_layout( filename )
      return unless filename
      filename = filename.to_s

      fn  = self.basename(filename)
      dir = ::File.dirname(filename)
      dir = '.' == dir ? '' : dir

      layouts.find(:filename => fn, :in_directory => dir)

    rescue RuntimeError
      raise Komo::Error, "could not find layout #{filename.inspect}"
    end

    # :stopdoc:
    def logger
      @logger ||= ::Logging::Logger[self]
    end
  end

end

require 'komo/resources/db'
require 'komo/resources/meta_file'
require 'komo/resources/resource'
require 'komo/resources/layout'
require 'komo/resources/page'
require 'komo/resources/page'
require 'komo/resources/static'
