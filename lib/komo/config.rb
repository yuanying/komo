require 'yaml'

class Komo::Config
  attr_reader :raw
  attr_reader :journal

  def initialize(path)
    root = File.dirname(path)
    @raw = YAML.load_file(path)
    @raw["root"] = root
    @journal = ::Komo::Journal.new
  end

  def root
    raw['root']
  end

  def site
    raw['site']
  end

  def content_dir
    return @content_dir if defined?(@content_dir)
    dir = raw['content_dir']
    @content_dir = File.join(root, dir || 'content')
  end

  def output_dir
    return @output_dir if defined?(@output_dir)
    dir = raw['output_dir']
    @output_dir = File.join(root, dir || 'output')
  end

  def layout_dir
    return @layout_dir if defined?(@layout_dir)
    dir = raw['layout_dir']
    @layout_dir = File.join(root, dir || 'layouts')
  end

  def metadata_defaults
    return @metadata_defaults if defined?(@metadata_defaults)
    @metadata_defaults = raw['metadata_defaults'] || { 'layout' => 'default' }
  end
end
