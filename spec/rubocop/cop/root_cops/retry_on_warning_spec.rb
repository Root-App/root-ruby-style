require_relative "../../../spec_helper.rb"

RSpec.describe RuboCop::Cop::RootCops::RetryOnWarning do
  subject(:cop) { described_class.new }

  it "reports an offense for retry_on" do
    expect_offense(<<~RUBY.strip_indent)
      retry_on StandardError
      ^^^^^^^^^^^^^^^^^^^^^^ Use care when implementing "retry_on". Look for side effects on the retried job before disabling warning.
    RUBY
  end

  it "doesn't report an offense for methods other than retry_on" do
    expect_no_offenses(<<~RUBY.strip_indent)
      retry_off StandardError
    RUBY
  end
end
