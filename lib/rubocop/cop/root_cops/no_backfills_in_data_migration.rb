module RuboCop
  module Cop
    module RootCops
      class NoBackfillsInDataMigration < Cop
        ACTIVE_RECORD_REGEX = /ActiveRecord::Migration\[\d\.\d\]/
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

        def on_class(node)
          parent_class_node = node.child_nodes[1]
          @is_migration_class = ACTIVE_RECORD_REGEX.match?(parent_class_node&.source)
        end

        def on_send(node)
          return unless @is_migration_class
          _receiver, method_name = *node
          if ACTIVE_RECORD_PERSISTENCE_METHODS.include?(method_name)
            add_offense(node, :location => :expression, :message => MESSAGE)
          end
        end
      end
    end
  end
end
