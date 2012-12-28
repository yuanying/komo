require 'hashie'
require 'deep_merge'

class Komo::Config

  DEFAULT = {
    :build => {
      :branch       => 'master',
      :working_dir  => Dir.pwd,
      :content_dir  => 'content',
      :output_dir   => 'output'
    }
  }

  def initialize path, options={}
    @raw = DEFAULT.dup
    @raw.deep_merge!(YAML.load(open(path).read))
    @raw.deep_merge!(options)
    @raw = Hashie::Mash.new(@raw)

    build = @raw.build
    def build.working_dir
      File.expand_path(self[:working_dir])
    end
  end

  def method_missing action, *args
    @raw.send(action, *args)
  end
end
