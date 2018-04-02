# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bu_pr/version'

Gem::Specification.new do |spec|
  spec.name          = "bu_pr"
  spec.version       = BuPr::VERSION
  spec.authors       = ["Masaya Myojin"]
  spec.email         = ["mmyoji@gmail.com"]

  spec.summary       = %q{Simple bundle update p-r creator}
  spec.description   = %q{BuPr is simple pull request creator for the daily bundle update.}
  spec.homepage      = "https://github.com/mmyoji/bu_pr"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "compare_linker", "~> 1.1.0"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
