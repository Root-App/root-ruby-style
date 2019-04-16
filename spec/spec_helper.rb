require "bundler"
require "rubocop/rspec/support"
require "rubocop/cop/root_cops/support/shared_examples"
require_relative "../lib/rubocop/cop/root_cops"

Bundler.require(:default, :development)

RSpec.configure do |config|
  config.order = :random
  config.raise_errors_for_deprecations!
  config.raise_on_warning = true
  # Very useful utility from Rubocop for testing linting rules
  config.include(RuboCop::RSpec::ExpectOffense)
end
