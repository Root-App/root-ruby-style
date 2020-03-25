RSpec.describe RuboCop::Cop::RootCops::UseLonelyOperator do
  subject(:cop) { described_class.new }

  it "reports an offense for try" do
    expect_offense(<<~RUBY.strip_indent)
      foo.try(:to_s)
      ^^^^^^^^^^^^^^ Use the lonely operator foo&.bar instead of foo.try(:bar)
    RUBY
  end

  it "reports an offense for try!" do
    expect_offense(<<~RUBY.strip_indent)
      foo.try!(:to_s)
      ^^^^^^^^^^^^^^^ Use the lonely operator foo&.bar instead of foo.try(:bar)
    RUBY
  end

  it "doesn't report an offense for methods other than try" do
    expect_no_offenses(<<~RUBY.strip_indent)
      foo.bar
    RUBY
  end
end
