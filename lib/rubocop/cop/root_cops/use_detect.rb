module RuboCop
  module Cop
    module RootCops
      class UseDetect < Cop
        MSG = "Use #detect instead of #find.".freeze

        def on_block(node)
          expanded_node = *node
          method_call_receiving_a_block = expanded_node[0]
          _receiver, method_name = *method_call_receiving_a_block
          if method_name == :find
            add_offense(node, :location => :expression, :message => MSG)
          end
        end
      end
    end
  end
end
