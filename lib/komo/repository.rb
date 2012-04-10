require 'grit'

class Komo::Repository
  attr_reader :repo
  attr_reader :branch

  def initialize options={}
    @repo   = Grit::Repo.new(File.expand_path(options[:path]))
    @branch = options[:branch] || 'master'
  end

  def copy_files target_dir
    
  end
end
