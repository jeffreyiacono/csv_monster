require File.expand_path('../lib/csv_monster/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jeff Iacono", "Joe Prang"]
  gem.email         = ["jeff.iacono@gmail.com", "joseph.prang@gmail.com"]
  gem.summary       = "A monster of a CSV util"
  gem.description   = "A set of utils for working with CSV files"
  gem.homepage      = ''
  gem.license       = 'MIT'
  gem.name          = 'csv_monster'
  gem.date          = '2013-06-19'
  gem.version       = CSVMonster::VERSION
  gem.require_paths = ["lib"]
  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_development_dependency "rake", ">= 12.3.3"
  gem.add_development_dependency "rspec", [">= 2"]
end
