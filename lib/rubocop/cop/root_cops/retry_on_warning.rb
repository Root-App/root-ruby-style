require "pry"
module RuboCop
  module Cop
    module RootCops
      class RetryOnWarning < Cop
        MSG = %(Use care when implementing "retry_on". Look for side effects on the retried job before disabling warning.).freeze

        def on_send(node)
          _receiver, method_name = *node

          if method_name == :retry_on
            add_offense(node, :location => :expression, :message => MSG)
          end
        end
      end
    end
  end
end
