require_relative 'lib/komo/version'

Gem::Specification.new do |spec|
  spec.name          = "komo"
  spec.version       = Komo::VERSION
  spec.authors       = ["OTSUKA, Yuanying"]
  spec.email         = ["yuanying@fraction.jp"]

  spec.summary       = "komo is static site generator in Ruby."
  spec.description   = "komo is static site generator in Ruby."
  spec.homepage      = "https://github.com/yuanying/komo"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency('logging', '=2.2.2')
  spec.add_dependency('rdiscount')
  spec.add_dependency('RedCloth')
end
