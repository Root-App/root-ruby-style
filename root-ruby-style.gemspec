lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# rubocop:disable RootCops/UseEnvvars

Gem::Specification.new do |gem|
  gem.name = "root-ruby-style"
  gem.version = "0.0.22"
  gem.authors = ["Root Devs"]
  gem.email = ["devs@joinroot.com"]

  gem.summary = "Root's Ruby/Rails Style Guide"

  gem.files = Dir.glob("lib/**/*.*") + [".rubocop.yml"]

  if ENV["BUILDKITE"]
    gem.metadata["allowed_push_host"] = "#{ENV["ARTIFACTORY_URL"]}/api/gems/engineering-ruby-gems"
  end

  gem.add_runtime_dependency "activesupport", ">= 5.0"
  gem.add_runtime_dependency "rubocop", "~> 1.76"
  gem.add_runtime_dependency "rubocop-factory_bot", "~> 2.27.1"
  gem.add_runtime_dependency "rubocop-performance", "~> 1.25.0"
  gem.add_runtime_dependency "rubocop-rails", "~> 2.31"
  gem.add_runtime_dependency "rubocop-rspec", "~> 3.6.0"

  gem.add_development_dependency "pry-byebug"
  gem.add_development_dependency "rspec", "~> 3.13"
end

# rubocop:enable RootCops/UseEnvvars
