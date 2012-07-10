require 'grit'

class Komo::Repository
  attr_reader :repo
  attr_reader :branch
  attr_reader :tree

  def initialize options={}
    @repo   = Grit::Repo.new(File.expand_path(options[:path]))
    @branch = options[:branch] || 'master'
    @tree   = @repo.commits(@branch).first.tree
  end

  def copy_files target_dir
    
  end

  def changed_files previous_rev=nil
  	unless previous_rev
      all_contents(tree)
    end
  end

  def all_contents tree, path=nil, rtn=[]
    tree.contents.each do |content|
      if content.kind_of?(Grit::Tree)
        all_contents(content, (path ? File.join(path, content.name) : content.name), rtn)
      else
        rtn << (path ? File.join(path, content.name) : content.name)
      end
    end
    rtn
  end
end
