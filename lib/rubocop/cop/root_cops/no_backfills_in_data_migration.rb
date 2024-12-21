module RuboCop
  module Cop
    module RootCops
      class NoBackfillsInDataMigration < Cop
        ACTIVE_RECORD_REGEX = /ActiveRecord::Migration\[\d\.\d\]/
        COLLAPSED_MIGRATION_CLASSNAME = "CollapsedMigrations".freeze
        MESSAGE = "Backfills should happen outside of database migrations".freeze
        ACTIVE_RECORD_PERSISTENCE_METHODS = %i[
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
        ].freeze
        OTHER_HARMFUL_METHODS = %i[execute].freeze
        FORBIDDEN_METHODS = ACTIVE_RECORD_PERSISTENCE_METHODS + OTHER_HARMFUL_METHODS

        def on_class(node)
          migration_class_node = node.child_nodes[0]
          parent_class_node = node.child_nodes[1]
          @is_migration_class = ACTIVE_RECORD_REGEX.match?(parent_class_node&.source)
          @is_collapsed_migration_class = migration_class_node&.source == COLLAPSED_MIGRATION_CLASSNAME
        end

        def on_send(node)
          return unless @is_migration_class

          _receiver, method_name = *node
          return if @is_collapsed_migration_class && method_name.to_s == "execute"

          if FORBIDDEN_METHODS.include?(method_name)
            add_offense(node, location: :expression, message: MESSAGE)
          end
        end
      end
    end
  end
end
