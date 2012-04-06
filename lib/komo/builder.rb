require 'komo'

class Komo::Builder

  def build(options={})
    repository  = Grit::Repo.new(File.expand_path(options[:repository]))
    branch      = options[:branch] || 'master'
    working_dir = File.expand_path(options[:working_dir] || Dir.pwd)

  end

end
