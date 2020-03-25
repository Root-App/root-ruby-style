require_relative "../../../spec_helper.rb"

RSpec.describe RuboCop::Cop::RootCops::UseChange do
  subject(:cop) { described_class.new }

  context "when migration does not have a #change method" do
    it "reports an offense" do
      expect_offense(<<~RUBY.strip_indent)
        class CreatePosts < ActiveRecord::Migration[6.0]
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #{described_class::MSG}
          def up
            create_table :posts do |t|
            end
          end

          def down
            remove_table :posts
          end
        end
      RUBY
    end
  end

  context "when the migration has a #change method" do
    it "does not report an offense" do
      expect_no_offenses(<<~RUBY.strip_indent)
        class CreatePosts < ActiveRecord::Migration[6.0]
          def change
            create_table :posts do |t|
            end
          end
        end
      RUBY
    end
  end
end
