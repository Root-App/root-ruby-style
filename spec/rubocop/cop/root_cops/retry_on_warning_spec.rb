RSpec.describe RuboCop::Cop::RootCops::RetryOnWarning do
  subject(:cop) { described_class.new }

  it "reports an offense for retry_on" do
    expect_offense(<<~RUBY)
      class RetryableJob
      ^^^^^^^^^^^^^^^^^^ When using "retry_on", ensure the job is idempotent and define a 'before_retry' to handle side effects or preconditions. NOTE: Jobs running on SQS cannot wait longer than 15 minutes for retry.
        retry_on StandardError
      end
    RUBY
  end

  it "doesn't report an offense if before_retry is implemented" do
    expect_no_offenses(<<~RUBY)
      class RetryableJob
        retry_off StandardError
        def perform(param_1:); end
        def before_retry(param_1:); end
      end
    RUBY
  end

  it "does report an offense if before_retry has a different method signature than perform" do
    expect_no_offenses(<<~RUBY)
      class AttemptBillingForAccountJob < ResqueJob
        retry_off StandardError
        def perform(param_1:); end
        def before_retry(param_2:); end
      end
    RUBY
  end

  it "doesn't report an offense outside of Job classes" do
    expect_no_offenses(<<~RUBY)
      retry_on StandardError
    RUBY
  end

  it "doesn't report an offense for methods other than retry_on" do
    expect_no_offenses(<<~RUBY)
      class RetryableJob
        retry_off StandardError
      end
    RUBY
  end
end
