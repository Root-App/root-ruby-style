RSpec.describe RuboCop::Cop::RootCops::PrivateMethods::CalledProtected do
  subject(:cop) { described_class.new }

  context "when the public modifier is used" do
    it "does not report an offense" do
      expect_no_offenses(<<~RUBY)
        module FooService
          public

          def self.method
            nil
          end
        end
      RUBY
    end
  end

  context "when the private modifier is used" do
    it "does not report an offense" do
      expect_no_offenses(<<~RUBY)
        module FooService
          def self.method
            _method
          end

          private

          def self._method
            nil
          end
        end
      RUBY
    end
  end

  context "when the protected modifier is used" do
    it "reports an offense" do
      expect_offense(<<~RUBY)
        module FooService
          def self.method
            _method
          end

          protected
          ^^^^^^^^^ RootCops/PrivateMethods/CalledProtected: Do not use protected. Use private instead.

          def self._method
            nil
          end
        end
      RUBY
    end
  end
end
