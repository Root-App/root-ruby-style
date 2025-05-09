module RuboCop
  module Cop
    module RootCops
      class UpAndDownOrChange < RuboCop::Cop::Base
        MSG = "Migration must have either #change or #up/#down".freeze

        def on_class(node)
          return unless active_record_migration?(node.parent_class)

          methods = node.each_descendant(:def).map { |n| n.children[0] }

          return if methods.include?(:change)
          return if methods.include?(:up) && methods.include?(:down)

          add_offense(node.loc.expression, message: MSG)
        end

        def_node_matcher :active_record_migration?, <<~PATTERN
          {(send (const (const nil? :ActiveRecord) :Migration) :[] (:float _))}
        PATTERN
      end
    end
  end
end
