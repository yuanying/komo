require 'komo'

class Komo::Builder
  attr_reader :repository
  attr_reader :working_dir

  def initialize repository, working_dir
    @repository   = Grit::Repo.new(File.expand_path(repository))
    @working_dir  = File.expand_path(working_dir)
  end

  def build!(options={})
    
  end

end
