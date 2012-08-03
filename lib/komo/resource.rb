require 'komo'
require "yaml"
require "fileutils"
require "digest/sha1"
require "date"

class Komo::RawResource
  attr_accessor :path, :metadata, :content
  def initialize(path)
    @path = path
    @data = File.read(path)
  end

  def parse
    pieces = @data.split(/^-{3,5}\s*$/)
    if pieces.length == 1 || @data.empty?
      self.metadata = Hash.new
      self.content  = pieces.first
    else
      self.metadata = begin
        YAML.load(pieces[1]).inject(Hash.new) { |metadata, pair| metadata.merge(pair[0].to_sym => pair[1]) } || Hash.new
      end
      self.content = pieces[2..-1].join.strip
    end

    set_timestamps_in_metadata
  end

  private
  def set_timestamps_in_metadata
    self.metadata[:created_at] ||= File.ctime(self.path)
    self.metadata[:updated_at] ||= File.mtime(self.path)
  end
end

class Komo::Resource
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String
  property :body,       Text

  property :path,       String
  property :created_at, DateTime
end
