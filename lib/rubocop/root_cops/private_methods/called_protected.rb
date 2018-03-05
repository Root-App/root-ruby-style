module RootCops
  module PrivateMethods
    class CalledProtected < ::RuboCop::Cop::Cop
      MSG = "Do not use protected. Use private instead.".freeze

      def on_send(node)
        _receiver, method_name = *node
        if method_name.to_s == "protected"
          add_offense(node, :selector, MSG)
        end
      end
    end
  end
end
