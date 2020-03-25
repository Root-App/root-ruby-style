active_record_persistence_methods = %w[
  decrement
  decrement!
  delete
  destroy
  destroy!
  increment
  increment!
  save
  save!
  toggle
  toggle!
  update
  update!
  update_attribute
  update_attribute!
  update_attributes
  update_attributes!
  update_column
  update_columns
]

RSpec.describe RuboCop::Cop::RootCops::NoBackfillsInDataMigration do
  subject(:cop) { described_class.new }

  active_record_persistence_methods.each do |method|
    it "adds an offense when the method #{method} is called within a method inside a migration", :aggregate_failures do
      arrow_string = "^" * (33 + method.length)
      error_message = "#{arrow_string} Backfills should happen outside of database migrations"

      expect_offense(<<~RUBY)
        class AddSendNotificationsToClaimUser < ActiveRecord::Migration[5.1]
          def change
            add_column :claim_users, :send_notifications, :boolean
            ClaimUser.all.each do |cu|
              cu.#{method}(:send_notifications => false)
              #{error_message}
            end
          end
        end
      RUBY
    end
  end

  active_record_persistence_methods.each do |method|
    it "adds an offense when the method #{method} is called within a private method inside a migration", :aggregate_failures do
      arrow_string = "^" * (33 + method.length)
      error_message = "#{arrow_string} Backfills should happen outside of database migrations"

      expect_offense(<<~RUBY)
        class AddSendNotificationsToClaimUser < ActiveRecord::Migration[5.1]
          def change
            add_column :claim_users, :send_notifications, :boolean
            _secretly_try_and_update_users
          end

          private

          def _secretly_try_and_update_users
            ClaimUser.all.each do |cu|
              cu.#{method}(:send_notifications => false)
              #{error_message}
            end
          end
        end
      RUBY
    end
  end

  context "when `execute` is called" do
    it "adds an offense" do
      expect_offense(<<~RUBY)
        class AddSendNotificationsToClaimUser < ActiveRecord::Migration[5.1]
          def up
            safety_assured { execute("potentially harmful sql") }
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Backfills should happen outside of database migrations
          end
        end
      RUBY
    end

    context "but it's in a non migration class" do
      it "doesn't add an offense" do
        expect_no_offenses(<<~RUBY)
          class CollapsedMigrations
            def up
              safety_assured { execute("potentially harmful sql") }
            end
          end
        RUBY
      end
    end

    context "but it's in the `CollapsedMigration` class" do
      it "doesn't add an offense" do
        expect_no_offenses(<<~RUBY)
          class CollapsedMigrations < ActiveRecord::Migration[5.1]
            def up
              safety_assured { execute("potentially harmful sql") }
            end
          end
        RUBY
      end
    end
  end

  context "when the class doesn't from ActiveRecord::Migration[\d.\d]" do
    it "doesn't add an offense" do
      expect_no_offenses(<<~RUBY)
        class AddSendNotificationsToClaimUser < ActiveRecord
          def up
            add_column :claim_users, :send_notifications, :boolean
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
            User.each { |user| user.update!(:foo => bar) }
          end
        end
      RUBY
    end
  end

  context "when no class is defined" do
    it "doesn't report an offense" do
      expect_no_offenses(<<~RUBY)
        def change
          User.each { |user| user.update!(:foo => bar) }
        end
      RUBY
    end
  end
end
