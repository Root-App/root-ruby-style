RSpec.describe RuboCop::Cop::RootCops::PrivateMethods::UnderscorePrefix do
  subject(:cop) { described_class.new }

  shared_examples_for "underscore prefix linting" do
    context "when writing a method above the private modifier" do
      context "when using an underscore prefix" do
        it "reports an offense" do
          expect_offense(<<~RUBY.strip_indent)
            #{module_or_class} FooService
              def self._method
              ^^^^^^^^^^^^^^^^ Include a private declaration above the private methods.
                nil
              end

              def _method
              ^^^^^^^^^^^ Include a private declaration above the private methods.
                nil
              end

              private
            end
          RUBY
        end
      end

      context "when not using an underscore prefix" do
        it "does not report an offense" do
          expect_no_offenses(<<~RUBY.strip_indent)
            #{module_or_class} FooService
              def self.method
                nil
              end

              def method
                nil
              end

              private
            end
          RUBY
        end
      end
    end

    context "when writing a method below the private modifier" do
      context "when not using an underscore prefix" do
        it "reports an offense" do
          expect_offense(<<~RUBY.strip_indent)
            #{module_or_class} FooService
              private

              def self.method
              ^^^^^^^^^^^^^^^ Prefix private method names with an underscore. If method should be public, move it above the private scope.
                nil
              end

              def method
              ^^^^^^^^^^ Prefix private method names with an underscore. If method should be public, move it above the private scope.
                nil
              end
            end
          RUBY
        end
      end

      context "when using an underscore prefix" do
        it "does not report an offense" do
          expect_no_offenses(<<~RUBY.strip_indent)
            #{module_or_class} FooService
              private

              def self._method
                nil
              end

              def _method
                nil
              end
            end
          RUBY
        end
      end
    end

    context "when in an inner-class/module under a private modifier" do
      context "when writing a method above the private modifier" do
        context "when using an underscore prefix" do
          it "reports an offense" do
            expect_offense(<<~RUBY.strip_indent)
              #{module_or_class} FooService
                private

                #{module_or_class} InnerService
                  def self._method
                  ^^^^^^^^^^^^^^^^ Include a private declaration above the private methods.
                    nil
                  end

                  def _method
                  ^^^^^^^^^^^ Include a private declaration above the private methods.
                    nil
                  end

                  private
                end
              end
            RUBY
          end
        end

        context "when not using an underscore prefix" do
          it "does not report an offense" do
            expect_no_offenses(<<~RUBY.strip_indent)
              #{module_or_class} FooService
                private

                #{module_or_class} InnerService
                  def self.method
                    nil
                  end

                  def method
                    nil
                  end
                end
              end
            RUBY
          end
        end
      end

      context "when writing a method below the private modifier" do
        context "when not using an underscore prefix" do
          it "reports an offense" do
            expect_offense(<<~RUBY.strip_indent)
              #{module_or_class} FooService
                private

                #{module_or_class} InnerService
                  private

                  def self.method
                  ^^^^^^^^^^^^^^^ Prefix private method names with an underscore. If method should be public, move it above the private scope.
                    nil
                  end

                  def method
                  ^^^^^^^^^^ Prefix private method names with an underscore. If method should be public, move it above the private scope.
                    nil
                  end
                end
              end
            RUBY
          end
        end

        context "when using an underscore prefix" do
          it "does not report an offense" do
            expect_no_offenses(<<~RUBY.strip_indent)
              #{module_or_class} FooService
                private

                #{module_or_class} InnerService
                  private

                  def self._method
                    nil
                  end

                  def _method
                    nil
                  end
                end
              end
            RUBY
          end
        end
      end
    end
  end

  context "when linting a class" do
    let(:module_or_class) { "class" }

    it_behaves_like "underscore prefix linting"
  end

  context "when linting a module" do
    let(:module_or_class) { "module" }

    it_behaves_like "underscore prefix linting"
  end
end
