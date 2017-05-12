# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'belzebuth/version'

Gem::Specification.new do |spec|
  spec.name          = "belzebuth"
  spec.version       = Belzebuth::VERSION
  spec.authors       = ["Pier-Hugues Pellerin"]
  spec.email         = ["phpellerin@gmail.com"]

  spec.summary       = %q{Small wrapper for testing external process}
  spec.description   = %q{Small wrapper for testing external process and synchronize suite}
  spec.homepage      = "http://github.com/ph/belzebuth"
  spec.licenses        = ['apache-2.0']

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "childprocess"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
