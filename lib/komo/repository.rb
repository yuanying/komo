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

  def new_files previous_rev=nil
  	unless previous_rev
      all_contents(tree)
    end
  end

  def modified_files previous_rev=nil
    unless previous_rev
      []
    end
  end

  def removed_files previous_rev=nil
    unless previous_rev
      []
    end
  end

  def all_contents tree, path=[], rtn=[]
    tree.contents.each do |content|
      if content.kind_of?(Grit::Tree)
        all_contents(content, path + [content.name], rtn)
      else
        rtn << (path + [content.name]).join('/')
      end
    end
    rtn
  end
end
