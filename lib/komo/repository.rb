require 'grit'

class Komo::Repository
  attr_reader :repo
  attr_reader :branch
  attr_reader :tree
  attr_reader :content

  def initialize options={}
    @repo     = Grit::Repo.new(File.expand_path(options[:path]))
    @branch   = options[:branch] || 'master'
    @tree     = @repo.commits(@branch).first.tree
    @content  = @tree / 'content'
  end

  def modified_files previous_rev=nil
    all_contents(content)
  end

  def removed_files previous_rev=nil
    # unless previous_rev
      []
    # end
  end

  def all_contents tree, path=[], rtn={}
    tree.contents.each do |content|
      if content.kind_of?(Grit::Tree)
        all_contents(content, path + [content.name], rtn)
      else
        rtn[(path + [content.name]).join('/')] = content
      end
    end
    rtn
  end
end
