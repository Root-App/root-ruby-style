module RuboCop
  module Cop
    module RootCops
      module PrivateMethods
        class CalledPrivateMethod < Cop
          MSG = "Do not call private class methods from outside the class. Make the method public if necessary.".freeze

          def on_send(node)
            receiver, method_name = *node
            if receiver && (method_name =~ /^_/)
              add_offense(node, :location => :selector, :message => MSG)
            end
          end
        end
      end
    end
  end
end
