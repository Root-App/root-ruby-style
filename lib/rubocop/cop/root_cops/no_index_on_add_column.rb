module RuboCop
  module Cop
    module RootCops
      class NoIndexOnAddColumn < RuboCop::Cop::Base
        ACTIVE_RECORD_REGEX = /ActiveRecord::Migration\[\d\.\d\]/
        COLLAPSED_MIGRATION_CLASSNAME = "CollapsedMigrations".freeze
        MESSAGE = "Do not use :index option on add_column".freeze

        def on_class(node)
          migration_class_node = node.child_nodes[0]
          parent_class_node = node.child_nodes[1]
          @is_migration_class = ACTIVE_RECORD_REGEX.match?(parent_class_node&.source)
          @is_collapsed_migration_class = migration_class_node&.source == COLLAPSED_MIGRATION_CLASSNAME
        end

        def on_send(node)
          return unless @is_migration_class
          return if @is_collapsed_migration_class

          _receiver, method_name, *_rest, last = *node
          return unless method_name == :add_column
          return unless last.is_a?(RuboCop::AST::HashNode)

          keys = last.keys.collect(&:value)

          add_offense(node.loc.expression, message: MESSAGE) if keys.include?(:index)
        end
      end
    end
  end
end
