module RuboCop
  module Cop
    module RootCops
      class UpAndDownOrChange < Cop
        MSG = "Migration must have either #change or #up/#down".freeze

        def on_class(node)
          methods = node.each_descendant(:def).map { |n| n.children[0] }

          return if methods.include?(:change)
          return if methods.include?(:up) && methods.include?(:down)

          add_offense(node, :location => :expression, :message => MSG)
        end
      end
    end
  end
end
