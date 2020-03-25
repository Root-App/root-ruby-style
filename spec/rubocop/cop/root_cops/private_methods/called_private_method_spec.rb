RSpec.describe RuboCop::Cop::RootCops::PrivateMethods::CalledPrivateMethod do
  subject(:cop) { described_class.new }

  context "when a public class method without arguments is called" do
    it "does not report an offense" do
      expect_no_offenses(<<~RUBY)
        def some_method
          SomeClass.a_public_method
        end
      RUBY
    end
  end

  context "when a public class method with arguments is called" do
    it "does not report an offense" do
      expect_no_offenses(<<~RUBY)
        def some_method
          SomeClass.a_public_method(:argument => 1)
        end
      RUBY
    end
  end

  context "when a 'private' class method without arguments is called" do
    it "reports an offense" do
      expect_offense(<<~RUBY)
        def some_method
          SomeClass._a_private_method
                    ^^^^^^^^^^^^^^^^^ Do not call private class methods from outside the class. Make the method public if necessary.
        end
      RUBY
    end
  end

  context "when a 'private' class method with arguments is called" do
    it "reports an offense" do
      expect_offense(<<~RUBY)
        def some_method
          SomeClass._a_private_method(:argument => 1)
                    ^^^^^^^^^^^^^^^^^ Do not call private class methods from outside the class. Make the method public if necessary.
        end
      RUBY
    end
  end
end
