# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hashcast/version'

Gem::Specification.new do |spec|
  spec.name          = "hashcast"
  spec.version       = HashCast::VERSION
  spec.authors       = ["Albert Gazizov", "Roman Heinrich"]
  spec.email         = ["deeper4k@gmail.com"]
  spec.description   = %q{Declarative Hash Caster}
  spec.summary       = %q{Declarative Hash Caster}
  spec.homepage      = "http://github.com/ddd-ruby/hashcast"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"


  spec.add_development_dependency "byebug",            '9.0.6'
  spec.add_development_dependency "bixby-bench",       '0.1.0'
  spec.add_development_dependency "allocation_stats",  '0.1.5'
  spec.add_development_dependency "codecov",           '0.1.9'
end
