RSpec.describe RuboCop::Cop::RootCops::Factories::FactoryFileName do
  subject(:cop) { described_class.new }

  context "when the file name is multiple words" do
    context "and the last word in the file name is pluralized" do
      before do
        allow(File).to receive(:basename).and_return("user_billings")
      end

      it "does not register an offense" do
        expect_no_offenses(<<-RUBY.strip_indent)
          FactoryBot.define do
          end
        RUBY
      end
    end

    context "and the last word in the file name is an invariant noun" do
      before do
        allow(File).to receive(:basename).and_return("billing_fish")
      end

      it "does not register an offense" do
        expect_no_offenses(<<-RUBY.strip_indent)
          FactoryBot.define do
          end
        RUBY
      end
    end

    context "and the last word in the file name is not pluralized" do
      before do
        allow(File).to receive(:basename).and_return("user_billing")
      end

      it "registers an offense" do
        expect_offense(<<-RUBY.strip_indent)
          FactoryBot.define do
          ^^^^^^^^^^^^^^^^^ Factory file name should be plural (user_billings).
          end
        RUBY
      end
    end
  end

  context "when the file name is one word" do
    context "and the file name is pluralized" do
      before do
        allow(File).to receive(:basename).and_return("billings")
      end

      it "does not register an offense" do
        expect_no_offenses(<<-RUBY.strip_indent)
          FactoryBot.define do
          end
        RUBY
      end
    end

    context "and the file name is an invariant noun" do
      before do
        allow(File).to receive(:basename).and_return("fish")
      end

      it "does not register an offense" do
        expect_no_offenses(<<-RUBY.strip_indent)
          FactoryBot.define do
          end
        RUBY
      end
    end

    context "and the file name is not pluralized" do
      before do
        allow(File).to receive(:basename).and_return("billing")
      end

      it "registers an offense" do
        expect_offense(<<-RUBY.strip_indent)
          FactoryBot.define do
          ^^^^^^^^^^^^^^^^^ Factory file name should be plural (billings).
          end
        RUBY
      end
    end
  end
end
