# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chicanery'

Gem::Specification.new do |gem|
  gem.name          = "chicanery"
  gem.version       = Chicanery::VERSION
  gem.authors       = ["Mark Ryall"]
  gem.email         = ["mark@ryall.name"]
  gem.description   = %q{trigger various events related to a continuous integration environment}
  gem.summary       = %q{polls various resources related to a ci environment and performs custom notifications}
  gem.homepage      = "http://github.com/markryall/chicanery"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'nokogiri', '~>1'

  gem.add_development_dependency 'rake', '~>0'
  gem.add_development_dependency 'rspec', '~>2'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'simplecov-gem-adapter'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'fakeweb'
end