require_relative "../../../spec_helper.rb"

RSpec.describe RuboCop::Cop::RootCops::NoIndexOnAddColumn do
  subject(:cop) { described_class.new }

  it "adds an offense when add_column is called with :index option" do
    error_message = "#{'^' * 70} Do not use :index option on add_column"
    expect_offense(<<~RUBY.strip_indent)
      class AddSendNotificationsToClaimUser < ActiveRecord::Migration[5.1]
        def change
          add_column :claim_users, :send_notifications, :boolean, :index => true
          #{error_message}
        end
      end
    RUBY
  end

  it "adds an offense when add_column is called with :index and other options" do
    error_message = "#{'^' * 89} Do not use :index option on add_column"
    expect_offense(<<~RUBY.strip_indent)
      class AddSendNotificationsToClaimUser < ActiveRecord::Migration[5.1]
        def change
          add_column :claim_users, :send_notifications, :boolean, :default => false, :index => true
          #{error_message}
        end
      end
    RUBY
  end

  it "does not add an offense when add_column is called without an :index option" do
    expect_no_offenses(<<~RUBY)
      class AddSendNotificationsToClaimUser < ActiveRecord::Migration[5.1]
        def change
          add_column :claim_users, :send_notifications, :boolean, :default => false
        end
      end
    RUBY
  end

  it "adds an offense when add_column is called with :index within a private method inside a migration" do
    error_message = "#{'^' * 70} Do not use :index option on add_column"
    expect_offense(<<~RUBY.strip_indent)
      class AddSendNotificationsToClaimUser < ActiveRecord::Migration[5.1]
        def change
          _secretly_try_and_add_an_indexed_column
        end

        private

        def _secretly_try_and_add_an_indexed_column
          add_column :claim_users, :send_notifications, :boolean, :index => true
          #{error_message}
        end
      end
    RUBY
  end

  context "when the class doesn't from ActiveRecord::Migration[\d.\d]" do
    it "doesn't add an offense" do
      expect_no_offenses(<<~RUBY)
        class AddSendNotificationsToClaimUser < ActiveRecord
          def up
            add_column :claim_users, :send_notifications, :boolean, :index => true
            ClaimUser.all.each do |cu|
              cu.update!(:send_notifications => false)
            end
            change_column_null :claim_users, :send_notifications, false
          end

          def down
            remove_column :claim_users, :send_notifications, :boolean
          end
        end
      RUBY
    end
  end

  context "when the class doesn't inherit from anything" do
    it "doesn't report an offense" do
      expect_no_offenses(<<~RUBY)
        class ThisIsAMigrationButItDoesNotInheritFromAnything
          def change
            add_column :foo, :bar, :string, :index => true
          end
        end
      RUBY
    end
  end

  context "when no class is defined" do
    it "doesn't report an offense" do
      expect_no_offenses(<<~RUBY)
        def change
          add_column :foo, :bar, :string, :index => true
        end
      RUBY
    end
  end
end
