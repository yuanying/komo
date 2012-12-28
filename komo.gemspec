# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "komo/version"

Gem::Specification.new do |s|
  s.name        = "komo"
  s.version     = Komo::VERSION
  s.authors     = ["yuanying"]
  s.email       = ["yuanying@fraction.jp"]
  s.homepage    = ""
  s.summary     = %q{Static site generator for Ruby.}
  s.description = %q{Static site generator for Ruby.}

  s.rubyforge_project = "komo"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = %w{komo} #`git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_runtime_dependency "data_mapper"
  s.add_runtime_dependency "dm-sqlite-adapter"
  s.add_runtime_dependency "dm-ar-finders"
  s.add_runtime_dependency "grit"
  s.add_runtime_dependency "hashie"
  s.add_runtime_dependency "deep_merge"
  s.add_runtime_dependency "rdiscount"
end
