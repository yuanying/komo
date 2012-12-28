
module Komo::Utils
  extend self

  def to_rel(base, target)
    sep = /#{File::SEPARATOR}+/o
    base = base.split(sep)
    # base.pop
    target = target.split(sep)
    while base.first == target.first
      base.shift
      target.shift
    end
    File.join([".."]*base.size+target)
  end
end
