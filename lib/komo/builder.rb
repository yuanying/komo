require 'komo'

class Komo::Builder

  # Build a site.
  #
  # @param [Hash] options
  # @option options [String] :working_dir
  # @option options [String] :branch        (optional)
  def build(options={})
    path        = File.expand_path(options[:working_dir] || Dir.pwd)
    branch      = options[:branch] || 'master'

    repository  = Komo::Repository.new(path: path, branch: branch)

    load_models(path)

    # TODO fix previous_rev parameter.
    repository.modified_files(nil).each do |path, file|
      metadata, content = nil, file.data
      if content.match(/^-{3,5}\s*$/)
        raw_resource = Komo::RawResource.new(path, file)
        metadata, content = raw_resource.parse
      end

      Komo::Resource.descendants.each do |resource_class|
        resource_class.resource_patterns.each do |pattern|
          if Regexp === pattern && pattern =~ path
            puts path
          elsif pattern.call(path, metadata)
            puts path
          end
        end
      end

    end
  end

  def load_models(path)
    Dir["#{path}/app/**/*.rb"].each do |file|
      load file
    end
    DataMapper.auto_upgrade!
  end
end
