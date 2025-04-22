RSpec.describe RuboCop::Cop::RootCops::UseLonelyOperator do
  subject(:cop) { described_class.new }

  it "reports an offense for try!" do
    expect_offense(<<~RUBY)
      foo.try!(:to_s)
          ^^^^ RootCops/UseLonelyOperator: Use the lonely operator foo&.bar instead of foo.try!(:bar)
    RUBY
  end

  it "doesn't report an offense for methods other than try!" do
    expect_no_offenses(<<~RUBY)
      foo.bar
    RUBY
  end

  it "doesn't report an offense for uses of try" do
    expect_no_offenses(<<~RUBY)
      experiment.try(:to_s)
    RUBY
  end

  it "doesn't report an offense for uses of try! that are not eligible for lonely operator" do
    expect_no_offenses(<<~RUBY)
      experiment.try! do
        some_code_to_try
      end
    RUBY
  end
end
