RSpec.describe RuboCop::Cop::RootCops::UnnecessaryAggregateFailures do
  subject(:cop) { described_class.new }

  context "when aggregate failures is the only metadata used in an `it` block's definition" do
    it "reports an offense" do
      expect_offense(<<~RUBY)
        let(:foo) { "bar" }

        it "asserts some functionality", :aggregate_failures do
                                         ^^^^^^^^^^^^^^^^^^^ RootCops/UnnecessaryAggregateFailures: :aggregate_failures is unnecessary, it is enabled by default.
          expect(foo).to eq("bar")
        end
      RUBY
    end
  end

  context "when there is additional metadata used in an `it` block's definition" do
    it "reports an offense" do
      expect_offense(<<~RUBY)
        let(:foo) { "bar" }

        it "asserts some functionality", :foo, :aggregate_failures, :bar do
                                               ^^^^^^^^^^^^^^^^^^^ RootCops/UnnecessaryAggregateFailures: :aggregate_failures is unnecessary, it is enabled by default.
          expect(foo).to eq("bar")
        end
      RUBY
    end
  end

  context "when aggregate failures is used in the body of an `it` block" do
    it "does not report an offense" do
      expect_no_offenses(<<~RUBY)
        it "asserts some functionality" do
          expect(:aggregate_failures).to eq(:aggregate_failures)
        end
      RUBY
    end
  end

  context "when aggregate failures is used elsewhere" do
    it "does not report an offense" do
      expect_no_offenses(<<~RUBY)
        class Foo
          def bar
            :aggregate_failures
          end
        end
      RUBY
    end
  end
end
