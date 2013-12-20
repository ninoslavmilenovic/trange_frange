# -*- encoding: utf-8 -*-

require File.expand_path('../lib/trange_frange/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'trange_frange'
  gem.version       = TrangeFrange::VERSION
  gem.summary       = %q{Tool for spelling amounts}
  gem.description   = %q{The tool spells out numbers (amounts) in words. It supports serbian language.}
  gem.license       = 'MIT'
  gem.authors       = ['Ninoslav Milenovic']
  gem.email         = 'nino.mil@gmail.com'
  gem.homepage      = 'https://github.com/pythogorian/trange_frange#readme'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rdoc', '~> 3.0'
  gem.add_development_dependency 'rspec', '~> 2.4'
end
