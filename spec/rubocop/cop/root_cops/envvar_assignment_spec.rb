RSpec.describe RuboCop::Cop::RootCops::EnvvarAssignment do
  subject(:cop) { described_class.new }

  context "when the file is not an initializer" do
    context "for general assignment" do
      it "reports an offense for ENVVARS constant assignment" do
        expect_offense(<<~RUBY.strip_indent)
          CONSTANT = ENVVARS["VAR"]
          ^^^^^^^^^^^^^^^^^^^^^^^^^ Do not assign an ENVVAR to a constant. Assigning an ENVVAR to a constant has unexpected behavior when used with set_environment_variable. Instead, return the ENVVAR from a method
        RUBY
      end

      it "reports an offense for ENVVARS constant assignment wrapped in another method" do
        expect_offense(<<~RUBY.strip_indent)
          CONSTANT = JSON.parse(ENVVARS["VAR"])
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not assign an ENVVAR to a constant. Assigning an ENVVAR to a constant has unexpected behavior when used with set_environment_variable. Instead, return the ENVVAR from a method
        RUBY
      end

      it "does not report an offense for normal constant assignment" do
        expect_no_offenses(<<~RUBY.strip_indent)
          CONSTANT = "string"
        RUBY
      end

      it "does not report an offense for normal ||= assignment" do
        expect_no_offenses(<<~RUBY.strip_indent)
          CONSTANT ||= 72.0
        RUBY
      end

      it "reports an offense for ENVVARS ||= assignment" do
        expect_offense(<<~RUBY.strip_indent)
          CONSTANT ||= ENVVARS["VAR"]
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not assign an ENVVAR to a constant. Assigning an ENVVAR to a constant has unexpected behavior when used with set_environment_variable. Instead, return the ENVVAR from a method
        RUBY
      end

      it "reports an offense for ENVVARS ||= assignment wrapped in another method" do
        expect_offense(<<~RUBY.strip_indent)
          CONSTANT ||= JSON.parse(ENVVARS["VAR"])
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not assign an ENVVAR to a constant. Assigning an ENVVAR to a constant has unexpected behavior when used with set_environment_variable. Instead, return the ENVVAR from a method
        RUBY
      end

      it "does not report an offense for assignment to ENVVARS" do
        expect_no_offenses(<<~RUBY.strip_indent)
          ENVVARS = {}
        RUBY
      end

      it "does not report an offense for ||= assignment to ENVVARS" do
        expect_no_offenses(<<~RUBY.strip_indent)
          ENVVARS ||= {}
        RUBY
      end
    end

    context "when the assignment is within a class" do
      it "reports an offense for ENVVARS constant assignment" do
        expect_offense(<<~RUBY.strip_indent)
          class MyClass
            CONSTANT = ENVVARS["VAR"]
            ^^^^^^^^^^^^^^^^^^^^^^^^^ Do not assign an ENVVAR to a constant. Assigning an ENVVAR to a constant has unexpected behavior when used with set_environment_variable. Instead, return the ENVVAR from a method
          end
        RUBY
      end

      it "reports an offense for ENVVARS constant assignment wrapped in another method" do
        expect_offense(<<~RUBY.strip_indent)
          class MyClass
            CONSTANT = JSON.parse(ENVVARS["VAR"])
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not assign an ENVVAR to a constant. Assigning an ENVVAR to a constant has unexpected behavior when used with set_environment_variable. Instead, return the ENVVAR from a method
          end
        RUBY
      end

      it "does not report an offense for normal constant assignment" do
        expect_no_offenses(<<~RUBY.strip_indent)
          class MyClass
            CONSTANT = "string"
          end
        RUBY
      end

      it "does not report an offense for normal ||= assignment" do
        expect_no_offenses(<<~RUBY.strip_indent)
          class MyClass
            CONSTANT ||= 72.0
          end
        RUBY
      end

      it "reports an offense for ENVVARS ||= assignment" do
        expect_offense(<<~RUBY.strip_indent)
          class MyClass
            CONSTANT ||= ENVVARS["VAR"]
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not assign an ENVVAR to a constant. Assigning an ENVVAR to a constant has unexpected behavior when used with set_environment_variable. Instead, return the ENVVAR from a method
          end
        RUBY
      end

      it "reports an offense for ENVVARS ||= assignment wrapped in another method" do
        expect_offense(<<~RUBY.strip_indent)
          class MyClass
            CONSTANT ||= JSON.parse(ENVVARS["VAR"])
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not assign an ENVVAR to a constant. Assigning an ENVVAR to a constant has unexpected behavior when used with set_environment_variable. Instead, return the ENVVAR from a method
          end
        RUBY
      end

      it "does not report an offense for assignment to ENVVARS" do
        expect_no_offenses(<<~RUBY.strip_indent)
          class MyClass
            ENVVARS = {}
          end
        RUBY
      end

      it "does not report an offense for ||= assignment to ENVVARS" do
        expect_no_offenses(<<~RUBY.strip_indent)
          class MyClass
            ENVVARS ||= {}
          end
        RUBY
      end
    end

    context "when the assignment is within a module" do
      it "reports an offense for ENVVARS constant assignment" do
        expect_offense(<<~RUBY.strip_indent)
          module MyModule
            CONSTANT = ENVVARS["VAR"]
            ^^^^^^^^^^^^^^^^^^^^^^^^^ Do not assign an ENVVAR to a constant. Assigning an ENVVAR to a constant has unexpected behavior when used with set_environment_variable. Instead, return the ENVVAR from a method
          end
        RUBY
      end

      it "reports an offense for ENVVARS constant assignment wrapped in another method" do
        expect_offense(<<~RUBY.strip_indent)
          module MyModule
            CONSTANT = JSON.parse(ENVVARS["VAR"])
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not assign an ENVVAR to a constant. Assigning an ENVVAR to a constant has unexpected behavior when used with set_environment_variable. Instead, return the ENVVAR from a method
          end
        RUBY
      end

      it "does not report an offense for normal constant assignment" do
        expect_no_offenses(<<~RUBY.strip_indent)
          module MyModule
            CONSTANT = "string"
          end
        RUBY
      end

      it "does not report an offense for normal ||= assignment" do
        expect_no_offenses(<<~RUBY.strip_indent)
          module MyModule
            CONSTANT ||= 72.0
          end
        RUBY
      end

      it "reports an offense for ENVVARS ||= assignment" do
        expect_offense(<<~RUBY.strip_indent)
          module MyModule
            CONSTANT ||= ENVVARS["VAR"]
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not assign an ENVVAR to a constant. Assigning an ENVVAR to a constant has unexpected behavior when used with set_environment_variable. Instead, return the ENVVAR from a method
          end
        RUBY
      end

      it "reports an offense for ENVVARS ||= assignment wrapped in another method" do
        expect_offense(<<~RUBY.strip_indent)
          module MyModule
            CONSTANT ||= JSON.parse(ENVVARS["VAR"])
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not assign an ENVVAR to a constant. Assigning an ENVVAR to a constant has unexpected behavior when used with set_environment_variable. Instead, return the ENVVAR from a method
          end
        RUBY
      end

      it "does not report an offense for assignment to ENVVARS" do
        expect_no_offenses(<<~RUBY.strip_indent)
          module MyModule
            ENVVARS = {}
          end
        RUBY
      end

      it "does not report an offense for ||= assignment to ENVVARS" do
        expect_no_offenses(<<~RUBY.strip_indent)
          module MyModule
            ENVVARS ||= {}
          end
        RUBY
      end
    end
  end

  context "when the file is an initializer" do
    let(:processed_source) { parse_source(source) }
    let(:filename) { "/config/initializers/file.rb" }

    before do
      allow(processed_source.buffer).to receive(:name).and_return(filename)
      _investigate(cop, processed_source)
    end

    context "ENVVARS constant assignment" do
      let(:source) do
        <<~RUBY.strip_indent
          CONSTANT = ENVVARS["VAR"]
        RUBY
      end

      it "does not report an offense" do
        expect(cop.offenses.size).to eq(0)
      end
    end

    context "ENVVARS constant ||= assignment" do
      let(:source) do
        <<~RUBY.strip_indent
          CONSTANT ||= ENVVARS["VAR"]
        RUBY
      end

      it "does not report an offense" do
        expect(cop.offenses.size).to eq(0)
      end
    end
  end
end
