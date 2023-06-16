RSpec.describe RuboCop::Cop::RootCops::AvoidRubyProf do
  subject(:cop) { described_class.new }

  let(:file_path) { "/tmp/avoid_ruby_prof_spec.rb" }

  before do
    allow_any_instance_of(RuboCop::ProcessedSource).to receive(:file_path).and_return(file_path) # rubocop:disable RSpec/AnyInstance
  end

  context "when ruby_prof is the only metadata used in a `describe` block's definition" do
    it "reports an offense" do
      expect_offense(<<~RUBY)
        describe "a class", :ruby_prof do
                            ^^^^^^^^^^ RootCops/AvoidRubyProf: :ruby_prof is for local use only and should not be committed.
          let(:foo) { "bar" }

          context "when tested" do
            it "asserts some functionality" do
              expect(foo).to eq("bar")
            end
          end
        end
      RUBY
    end
  end

  context "when ruby_prof is the only metadata used in a `context` block's definition" do
    it "reports an offense" do
      expect_offense(<<~RUBY)
        describe "a class" do
          let(:foo) { "bar" }

          context "when tested", :ruby_prof do
                                 ^^^^^^^^^^ RootCops/AvoidRubyProf: :ruby_prof is for local use only and should not be committed.
            it "asserts some functionality" do
              expect(foo).to eq("bar")
            end
          end
        end
      RUBY
    end
  end

  context "when ruby_prof is the only metadata used in an `it` block's definition" do
    it "reports an offense" do
      expect_offense(<<~RUBY)
        let(:foo) { "bar" }

        it "asserts some functionality", :ruby_prof do
                                         ^^^^^^^^^^ RootCops/AvoidRubyProf: :ruby_prof is for local use only and should not be committed.
          expect(foo).to eq("bar")
        end
      RUBY
    end
  end

  context "when there is additional metadata used in an `it` block's definition" do
    it "reports an offense" do
      expect_offense(<<~RUBY)
        let(:foo) { "bar" }

        it "asserts some functionality", :foo, :ruby_prof, :bar do
                                               ^^^^^^^^^^ RootCops/AvoidRubyProf: :ruby_prof is for local use only and should not be committed.
          expect(foo).to eq("bar")
        end
      RUBY
    end
  end

  context "when ruby_prof is used in the body of an `it` block" do
    it "does not report an offense" do
      expect_no_offenses(<<~RUBY)
        it "asserts some functionality" do
          expect(:ruby_prof).to eq(:ruby_prof)
        end
      RUBY
    end
  end

  context "when ruby_prof is used elsewhere" do
    it "does not report an offense" do
      expect_no_offenses(<<~RUBY)
        class Foo
          def bar
            :ruby_prof
          end
        end
      RUBY
    end
  end

  context "when ruby_prof used outside of a spec file" do
    let(:file_path) { "/tmp/avoid_ruby_prof.rb" }

    it "does not report an offense" do
      expect_no_offenses(<<~RUBY)
        it "asserts some functionality", :ruby_prof do
          expect(true).to eq(true)
        end
      RUBY
    end
  end
end
