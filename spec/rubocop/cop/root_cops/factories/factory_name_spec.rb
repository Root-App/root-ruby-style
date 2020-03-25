RSpec.describe RuboCop::Cop::RootCops::Factories::FactoryName do
  subject(:cop) { described_class.new }

  context "when the factory file name is incorrect" do
    before do
      allow(File).to receive(:basename).and_return("user_billing")
    end

    it "skips all factory name checks and registers no offenses" do
      expect_no_offenses(<<-RUBY)
        FactoryBot.define do
          factory :user_billing do
            ref { "new-branch" }
            ref_type { "branch" }
            master_branch { "master" }
          end

          factory :user_billings__payment do
            ref { "new-branch" }
            ref_type { "branch" }
            master_branch { "master" }
          end

          factory :payment do
            ref { "new-branch" }
            ref_type { "branch" }
            master_branch { "master" }
          end

          factory :user_billings do
            ref { "new-branch" }
            ref_type { "branch" }
            master_branch { "master" }
          end

          factory :user_billing__payment do
            ref { "new-branch" }
            ref_type { "branch" }
            master_branch { "master" }
          end
        end
      RUBY
    end
  end

  context "when the factory file name is correct" do
    context "when the last word in the file name is pluralized" do
      before do
        allow(File).to receive(:basename).and_return("user_billings")
      end

      context "and the factory name equals the file name" do
        it "does not register an offense" do
          expect_no_offenses(<<-RUBY)
            FactoryBot.define do
              factory :user_billings do
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end
            end
          RUBY
        end
      end

      context "and the factory name equals the singular version of the file name." do
        it "does not register an offense" do
          expect_no_offenses(<<-RUBY)
            FactoryBot.define do
              factory :user_billing do
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end
            end
          RUBY
        end
      end

      context "and the factory name does not equal the file name or the singular version of the file name" do
        it "registers an offense" do
          expect_offense(<<-RUBY)
            FactoryBot.define do
              factory :payment do
              ^^^^^^^^^^^^^^^^ Factory should be in own file or be named the singular form of the file name. OR group closely related factories in the same file and prefix their names with 'user_billings__'.
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end
              factory :users_billing do
              ^^^^^^^^^^^^^^^^^^^^^^ Factory should be in own file or be named the singular form of the file name. OR group closely related factories in the same file and prefix their names with 'user_billings__'.
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end
              factory :users_billings do
              ^^^^^^^^^^^^^^^^^^^^^^^ Factory should be in own file or be named the singular form of the file name. OR group closely related factories in the same file and prefix their names with 'user_billings__'.
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end
            end
          RUBY
        end
      end

      context "and the factory uses the file name as a prefix" do
        it "does not register an offense" do
          expect_no_offenses(<<-RUBY)
            FactoryBot.define do
              factory :user_billings__payment do
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end
            end
          RUBY
        end
      end

      context "and the factory name uses an incorrect prefix" do
        it "registers an offense" do
          expect_offense(<<-RUBY)
            FactoryBot.define do
              factory :user_billing__payment do
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Factory name uses incorrect prefix, should be 'user_billings__payment'.
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end
              factory :users_billing__payment do
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Factory name uses incorrect prefix, should be 'user_billings__payment'.
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end
              factory :users_billings__payment do
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Factory name uses incorrect prefix, should be 'user_billings__payment'.
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end
            end
          RUBY
        end
      end

      context "and there are multiple offenses" do
        it "registers all the offenses" do
          expect_offense(<<-RUBY)
            FactoryBot.define do
              factory :user_billing do
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end

              factory :user_billings do
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end

              factory :user_billings__payment do
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end

              factory :payment do
              ^^^^^^^^^^^^^^^^ Factory should be in own file or be named the singular form of the file name. OR group closely related factories in the same file and prefix their names with 'user_billings__'.
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end

              factory :user_billing__payment do
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Factory name uses incorrect prefix, should be 'user_billings__payment'.
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end
            end
          RUBY
        end
      end
    end

    context "when the last word in the file name is an invariant noun" do
      before do
        allow(File).to receive(:basename).and_return("billing_fish")
      end

      context "and the factory name equals the file name" do
        it "does not register an offense" do
          expect_no_offenses(<<-RUBY)
            FactoryBot.define do
              factory :billing_fish do
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end
            end
          RUBY
        end
      end

      context "and the factory name does not equal the the file name" do
        it "registers an offense" do
          expect_offense(<<-RUBY)
            FactoryBot.define do
              factory :payment do
              ^^^^^^^^^^^^^^^^ Factory should be in own file or be named the singular form of the file name. OR group closely related factories in the same file and prefix their names with 'billing_fish__'.
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end
              factory :billings_fish do
              ^^^^^^^^^^^^^^^^^^^^^^ Factory should be in own file or be named the singular form of the file name. OR group closely related factories in the same file and prefix their names with 'billing_fish__'.
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end
            end
          RUBY
        end
      end

      context "and the factory uses the file name as a prefix" do
        it "does not register an offense" do
          expect_no_offenses(<<-RUBY)
            FactoryBot.define do
              factory :billing_fish__payment do
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end
            end
          RUBY
        end
      end

      context "and the factory name uses an incorrect prefix" do
        it "registers an offense" do
          expect_offense(<<-RUBY)
            FactoryBot.define do
              factory :billing__payment do
              ^^^^^^^^^^^^^^^^^^^^^^^^^ Factory name uses incorrect prefix, should be 'billing_fish__payment'.
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end
              factory :billing_fishes__payment do
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Factory name uses incorrect prefix, should be 'billing_fish__payment'.
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end
            end
          RUBY
        end
      end

      context "and there are multiple offenses" do
        it "registers all the offenses" do
          expect_offense(<<-RUBY)
            FactoryBot.define do
              factory :billing_fish do
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end

              factory :billing_fish__payment do
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end

              factory :payment do
              ^^^^^^^^^^^^^^^^ Factory should be in own file or be named the singular form of the file name. OR group closely related factories in the same file and prefix their names with 'billing_fish__'.
                ref { "new-branch" }
                ref_type { "branch" }
                master_branch { "master" }
              end

              factory :billing__payment do
              ^^^^^^^^^^^^^^^^^^^^^^^^^ Factory name uses incorrect prefix, should be 'billing_fish__payment'.
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
end
