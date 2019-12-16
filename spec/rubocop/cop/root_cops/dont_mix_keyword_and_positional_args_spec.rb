require_relative "../../../spec_helper.rb"

RSpec.describe RuboCop::Cop::RootCops::DontMixKeywordAndPositionalArgs do
  subject(:cop) { described_class.new }

  it "does not report an offense for normal, optional, and rest positional args" do
    expect_no_offenses(<<~RUBY.strip_indent)
      def meth(positional, optional = 3, *rest); end
    RUBY
  end

  it "does not report an offense for normal, optional, and rest keyword args" do
    expect_no_offenses(<<~RUBY.strip_indent)
      def meth(kwarg:, opt_kwarg: 3, **rest_kwarg); end
    RUBY
  end

  it "reports an offense when using positional and keyword args (example 1)" do
    expect_offense(<<~RUBY.strip_indent)
      def meth(positional, kwarg:); end
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not mix keyword args and positional args
    RUBY
  end

  it "reports an offense when using positional and keyword args (example 2)" do
    expect_offense(<<~RUBY.strip_indent)
      def meth(opt_positional = 3, opt_kwarg: 3); end
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not mix keyword args and positional args
    RUBY
  end

  it "reports an offense when using positional and keyword args (example 3)" do
    expect_offense(<<~RUBY.strip_indent)
      def meth(positional, opt_positional = 3, kwarg:); end
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not mix keyword args and positional args
    RUBY
  end

  it "reports an offense when using positional and keyword args (example 4)" do
    expect_offense(<<~RUBY.strip_indent)
      def meth(positional, opt_positional = 3, kwarg:, opt_kwarg: 5); end
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not mix keyword args and positional args
    RUBY
  end

  it "reports an offense when using positional and keyword args (example 5)" do
    expect_offense(<<~RUBY.strip_indent)
      def meth(*rest, **rest_kwargs); end
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not mix keyword args and positional args
    RUBY
  end
end
