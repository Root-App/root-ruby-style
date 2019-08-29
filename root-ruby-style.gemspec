lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "root-ruby-style"
  gem.version       = "0.0.2"
  gem.authors       = ["Root Devs"]
  gem.email         = ["devs@joinroot.com"]

  gem.summary       = "Root's Ruby/Rails Style Guide"

  gem.add_runtime_dependency "activesupport", "~> 5.0"
  gem.add_runtime_dependency "rubocop", "~> 0.74.0"
  gem.add_runtime_dependency "rubocop-performance", "1.4.1"
  gem.add_runtime_dependency "rubocop-rails", "~> 2.3.1"
  gem.add_runtime_dependency "rubocop-rspec", "~> 1.35.0"

  gem.add_development_dependency "pry-byebug"
  gem.add_development_dependency "rspec", "~> 3.8"
end
