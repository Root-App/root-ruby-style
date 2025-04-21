module RuboCop
  module Cop
    module RootCops
      class UnnecessaryAggregateFailures < RuboCop::Cop::Base
        ERROR = ":aggregate_failures is unnecessary, it is enabled by default.".freeze

        def_node_matcher :it_block?, <<~PATTERN
          (send nil? :it ...)
        PATTERN

        def on_sym(node)
          return unless node.value == :aggregate_failures && it_block?(node.parent)

          add_offense(node.loc.expression, message: ERROR)
        end
      end
    end
  end
end
