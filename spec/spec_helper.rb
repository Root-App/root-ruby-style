require "bundler/setup"
require "pry"
require_relative "../lib/rubocop/cop/root_cops"
require "rubocop/rspec/support"
require "rubocop/cop/root_cops/support/shared_examples"

RSpec.configure do |config|
  config.order = :random
  config.raise_errors_for_deprecations!
  config.raise_on_warning = true
  # Very useful utility from Rubocop for testing linting rules
  config.include(RuboCop::RSpec::ExpectOffense)
end
