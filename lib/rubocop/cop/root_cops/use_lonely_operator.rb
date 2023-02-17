module RuboCop
  module Cop
    module RootCops
      class UseLonelyOperator < Cop
        MSG = "Use the lonely operator foo&.bar instead of foo.try!(:bar)".freeze

        def on_send(node)
          _receiver, method_name = *node

          if method_name == :try! && node.arguments?
            add_offense(node, :location => :expression, :message => MSG)
          end
        end
      end
    end
  end
end
