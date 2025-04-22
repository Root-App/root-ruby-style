module RuboCop
  module Cop
    module RootCops
      module PrivateMethods
        class CalledProtected < RuboCop::Cop::Base
          MSG = "Do not use protected. Use private instead.".freeze

          def on_send(node)
            _receiver, method_name = *node
            if method_name.to_s == "protected"
              add_offense(node.loc.selector, message: MSG)
            end
          end
        end
      end
    end
  end
end
