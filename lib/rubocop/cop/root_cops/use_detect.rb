module RuboCop
  module Cop
    module RootCops
      # prefer `Enumerable#detect` over `Enumerable#find`
      #
      # @example
      #   # bad
      #   [1,2,3].find { |x| x.even? }
      #   [1,2,3].find(&:even?)
      #
      #   # good
      #   [1,2,3].detect { |x| x.even? }
      #   [1,2,3].detect(&:even?)

      class UseDetect < RuboCop::Cop::Base
        MSG = "Use #detect instead of #find.".freeze

        def anything_other_than_class_constant?(node)
          return true unless node&.const_type?

          node.const_name == node.const_name.upcase
        end

        def_node_matcher :find_called_with_a_block?, <<~PATTERN
          (block
            (send
              #anything_other_than_class_constant?
              :find
              ...)
            ...)
        PATTERN

        def on_block(node)
          find_called_with_a_block?(node) do
            add_offense(node.loc.expression, message: MSG)
          end
        end

        def_node_matcher :find_called_with_a_block_as_proc?, <<~PATTERN
          (send
            #anything_other_than_class_constant?
            :find
            (block_pass ...))
        PATTERN

        def on_send(node)
          find_called_with_a_block_as_proc?(node) do
            add_offense(node.loc.expression, message: MSG)
          end
        end
      end
    end
  end
end
