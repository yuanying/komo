require 'komo'
require "yaml"
require "fileutils"
require "digest/sha1"
require "date"
require 'dm-timestamps'

class Komo::RawResource
  attr_accessor :path, :metadata, :content
  def initialize(path, data)
    @path     = path
    parse data
  end

  def parse data
    pieces = data.split(/^-{3,5}\s*$/)
    if pieces.length == 1 || data.empty?
      self.metadata = nil
      self.content  = pieces.first
    else
      self.metadata = begin
        YAML.load(pieces[1]).inject(Hash.new) { |metadata, pair| metadata.merge(pair[0].to_sym => pair[1]) } || Hash.new
      end
      self.metadata = Hashie::Mash.new(self.metadata)
      self.content  = pieces[2..-1].join.strip
    end

    set_timestamps_in_metadata

    [self.metadata, self.content]
  end

  private
  def set_timestamps_in_metadata
    # self.metadata[:created_at] ||= File.ctime(self.path)
    # self.metadata[:updated_at] ||= File.mtime(self.path)
  end
end

class Komo::Resource
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String
  # property :body,       Text

  property :path,       String,   key: true
  property :created_at, DateTime
  property :posted_at,  DateTime

  property :type, Discriminator

  attr_reader :metadata, :raw_content

  def self.config=(config)
    @@config = config
  end

  def self.config
    @@config
  end

  def self.resource_type
    self.name.downcase
  end

  def self.find_or_create_or_destroy raw_resource
    if self.resource_type == raw_resource.metadata[:type]
      rep = self.first_or_create(:path => raw_resource.path)
      rep.raw_resource = raw_resource
      rep.save!
      return [rep]
    else
      self.all(:path => raw_resource.path).each do |rep|
        rep.destroy
      end
      return []
    end
  end

  def self.pre_process_all(raw_resource)
    Komo::Resource.descendants.each do |rep_class|
      rep_class.pre_process(raw_resource)
    end
  end

  def self.pre_process(raw_resource)
    # abstract method
    self.find_or_create_or_destroy(raw_resource).each do |rep|
      self.modified_resources << rep 
    end
  end

  def self.modified_resources
    @@modified_resources ||= []
    @@modified_resources
  end

  def self.filters
    @filters ||= Array.new
  end

  def self.filter=(filter)
    self.filters << filter
  end

  def self.extension=(extension)
    extension = extension
  end

  def self.extension
    extension || '.html'
  end

  def self.layout=(layout)
    @layout = layout
  end

  def self.layout
    @layout || 'default'
  end

  def config
    self.class.config
  end

  def output_path(page=0)
    output_path = File.join(self.config.build.working_dir, self.config.build.output_dir, path.sub(self.config.build.content_dir, ''))

    ext       = self.class.extension
    basename  = File.basename(output_path, '.*')
    dirname   = File.dirname(output_path)

    page      = page == 0 ? '' : "#{page}"

    File.join(dirname, "#{basename}#{page}#{ext}")
  end

  def url(page=0)
    url = output_path(page).sub(File.join(self.config.build.working_dir, self.config.build.output_dir), '')
    url = File.join('', url)

    ext       = File.extension(url)
    basename  = File.basename(url)
    if basename == 'index.html'
      url.sub!(/index.html$/, '')
    elsif ext == '.html'
      url.sub!(/#{ext}$/, '')
    end
    url
  end

  def raw_resource=(raw_resource)
    self.title      = raw_resource.metadata.title
    if raw_resource.metadata.created_at && (self.created_at != raw_resource.metadata.created_at)
      self.created_at = raw_resource.metadata.created_at
    end
    if raw_resource.metadata.posted_at && (self.posted_at != raw_resource.metadata.posted_at)
      self.posted_at  = raw_resource.metadata.posted_at
    end

    @metadata       = raw_resource.metadata
    @raw_content    = raw_resource.content
  end

end
