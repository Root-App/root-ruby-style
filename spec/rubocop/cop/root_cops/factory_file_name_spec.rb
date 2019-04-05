require_relative "../../../spec_helper.rb"

RSpec.describe RuboCop::Cop::RootCops::FactoryFileName do
  subject(:cop) { described_class.new }

  context "when the file name has an underscore" do
    before do
      allow(File).to receive(:basename).and_return("factory_name")
    end

    context "when the factory name matches the file name" do
      it "does not register an offense" do
        expect_no_offenses(<<-RUBY.strip_indent)
          FactoryBot.define do
            factory :factory_name do
              ref { "new-branch" }
              ref_type { "branch" }
              master_branch { "master" }
            end
          end
        RUBY
      end
    end

    context "when the factory name does not match the file name" do
      it "registers an offense" do
        expect_offense(<<-RUBY.strip_indent)
          FactoryBot.define do
            factory :other_factory do
            ^^^^^^^^^^^^^^^^^^^^^^ Factory name should match file name
              ref { "new-branch" }
              ref_type { "branch" }
              master_branch { "master" }
            end
          end
        RUBY
      end
    end

    context "when there are closely related factories in the same file" do
      it "does not register an offense" do
        expect_no_offenses(<<-RUBY.strip_indent)
          FactoryBot.define do
            factory :factory_name do
              ref { "new-branch" }
              ref_type { "branch" }
              master_branch { "master" }
            end
          end

          FactoryBot.define do
            factory :factory_name__related_factory do
              ref { "new-branch" }
              ref_type { "branch" }
              master_branch { "master" }
            end
          end
        RUBY
      end
    end

    context "when there are factories with completely different names in the same file" do
      it "registers an offense" do
        expect_offense(<<-RUBY.strip_indent)
          FactoryBot.define do
            factory :factory_name do
              ref { "new-branch" }
              ref_type { "branch" }
              master_branch { "master" }
            end
            factory :other_factory do
            ^^^^^^^^^^^^^^^^^^^^^^ Factory name should match file name
              ref { "new-branch" }
              ref_type { "branch" }
              master_branch { "master" }
            end
          end
        RUBY
      end
    end
  end

  context "when the file name does not have an underscore" do
    before do
      allow(File).to receive(:basename).and_return("factory")
    end

    context "when the factory name matches the file name" do
      it "does not register an offense" do
        expect_no_offenses(<<-RUBY.strip_indent)
          FactoryBot.define do
            factory :factory do
              ref { "new-branch" }
              ref_type { "branch" }
              master_branch { "master" }
            end
          end
        RUBY
      end
    end

    context "when the factory name does not match the file name" do
      it "registers an offense" do
        expect_offense(<<-RUBY.strip_indent)
          FactoryBot.define do
            factory :other do
            ^^^^^^^^^^^^^^ Factory name should match file name
              ref { "new-branch" }
              ref_type { "branch" }
              master_branch { "master" }
            end
          end
        RUBY
      end
    end

    context "when there are closely related factories in the same file" do
      it "does not register an offense" do
        expect_no_offenses(<<-RUBY.strip_indent)
          FactoryBot.define do
            factory :factory do
              ref { "new-branch" }
              ref_type { "branch" }
              master_branch { "master" }
            end
          end

          FactoryBot.define do
            factory :factory__related_factory do
              ref { "new-branch" }
              ref_type { "branch" }
              master_branch { "master" }
            end
          end
        RUBY
      end
    end

    context "when there are factories with completely different names in the same file" do
      it "registers an offense" do
        expect_offense(<<-RUBY.strip_indent)
          FactoryBot.define do
            factory :factory do
              ref { "new-branch" }
              ref_type { "branch" }
              master_branch { "master" }
            end
            factory :other do
            ^^^^^^^^^^^^^^ Factory name should match file name
              ref { "new-branch" }
              ref_type { "branch" }
              master_branch { "master" }
            end
          end
        RUBY
      end
    end
  end
end
