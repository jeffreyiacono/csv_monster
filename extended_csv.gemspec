require File.expand_path('../lib/extended_csv/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jeff Iacono"]
  gem.email         = ["iacono@squarup.com"]
  gem.summary       = "Extending the CSV module with some additional methods to allow for easier processing of larger CSV files"
  gem.description   = "Extending the CSV module with some additional methods to allow for easier processing of larger CSV files"
  gem.homepage      = ''
  gem.license       = 'MIT'
  gem.name          = 'extended_csv'
  gem.date          = '2013-06-19'
  gem.version       = ExtendedCSV::VERSION
  gem.require_paths = ["lib"]
  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_runtime_dependency "activesupport", [">= 3.2.3"]

  gem.add_development_dependency "rake"
  gem.add_development_dependency "cane"
  gem.add_development_dependency "rspec", [">= 2"]
end
