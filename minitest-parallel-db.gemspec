# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minitest/parallel/db/version'

Gem::Specification.new do |spec|
  spec.name          = "minitest-parallel-db"
  spec.version       = Minitest::Parallel::Db::VERSION
  spec.authors       = ["Jared Ning"]
  spec.email         = ["jared@redningja.com"]
  spec.description   = %q{Run tests in parallel with a database}
  spec.summary       = %q{Run tests in parallel with a database}
  spec.homepage      = "https://github.com/ordinaryzelig/minitest-parallel-db"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'minitest', '>= 4.2'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "pg"
  spec.add_development_dependency "sequel"
  spec.add_development_dependency "activerecord"
end
