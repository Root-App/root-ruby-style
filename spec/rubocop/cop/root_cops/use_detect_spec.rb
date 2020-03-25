RSpec.describe RuboCop::Cop::RootCops::UseDetect do
  subject(:cop) { described_class.new }

  it "reports an offense for array literal find" do
    expect_offense(<<~RUBY.strip_indent)
      [1,2,3].find { |x| x.even? }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use #detect instead of #find.
    RUBY
  end

  it "reports an offense for variable find" do
    expect_offense(<<~RUBY.strip_indent)
      something.find { |x| x.even? }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use #detect instead of #find.
    RUBY
  end

  it "reports an offense for symbolized block find" do
    expect_offense(<<~RUBY.strip_indent)
      something.find(&:even?)
      ^^^^^^^^^^^^^^^^^^^^^^^ Use #detect instead of #find.
    RUBY
  end

  it "doesn't report an offense for AR find" do
    expect_no_offenses(<<~RUBY.strip_indent)
      InsuranceCompany.find(root_id)
    RUBY
  end

  it "doesn't report an offense for custom method called find" do
    expect_no_offenses(<<~RUBY.strip_indent)
      FinderService.find(:thing => :stuff)
    RUBY
  end

  it "doesn't report an offense for Find.find" do
    expect_no_offenses(<<~RUBY.strip_indent)
      Find.find(ENV["HOME"]) do |path|
        puts path
      end
    RUBY
  end

  it "doesn't report an offense for Find.find with symbol to proc. why would you do this? good question. idk" do
    expect_no_offenses(<<~RUBY.strip_indent)
      Find.find(ENV["HOME"], &:inspect)
    RUBY
  end

  it "does report an offense for constant find" do
    expect_offense(<<~RUBY.strip_indent)
      NUMBERS.find { |x| x.even? }
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use #detect instead of #find.
    RUBY
  end

  it "does report an offense for constant find symbol to proc" do
    expect_offense(<<~RUBY.strip_indent)
      NUMBERS.find(&:even?)
      ^^^^^^^^^^^^^^^^^^^^^ Use #detect instead of #find.
    RUBY
  end
end
