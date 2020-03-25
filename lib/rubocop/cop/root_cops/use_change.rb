module RuboCop
  module Cop
    module RootCops
      class UseChange < Cop
        MSG = "Migration must have #change method.".freeze

        def on_class(node)
          return if node.each_descendant(:def).any? { |n| n.children[0] == :change }

          add_offense(node, :location => :expression, :message => MSG)
        end
      end
    end
  end
end
