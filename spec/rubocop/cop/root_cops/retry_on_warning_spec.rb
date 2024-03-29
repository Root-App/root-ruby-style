RSpec.describe RuboCop::Cop::RootCops::RetryOnWarning do
  subject(:cop) { described_class.new }

  it "reports an offense for retry_on" do
    expect_offense(<<~RUBY)
      retry_on StandardError
      ^^^^^^^^^^^^^^^^^^^^^^ RootCops/RetryOnWarning: Use care when implementing "retry_on". Look for side effects on the retried job before disabling warning. NOTE: Jobs running on SQS cannot wait longer than 15 minutes for retry.
    RUBY
  end

  it "doesn't report an offense for methods other than retry_on" do
    expect_no_offenses(<<~RUBY)
      retry_off StandardError
    RUBY
  end
end
