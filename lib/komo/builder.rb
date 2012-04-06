require 'komo'

class Komo::Builder

  # Build a site.
  #
  # @param [Hash] options
  # @option options [String] :repository
  # @option options [String] :branch        (optional)
  # @option options [String] :working_dir   (optional)
  def build(options={})
    repository  = Grit::Repo.new(File.expand_path(options[:repository]))
    branch      = options[:branch] || 'master'
    working_dir = File.expand_path(options[:working_dir] || Dir.pwd)

  end

end
