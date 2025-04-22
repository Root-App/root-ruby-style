module RuboCop
  module Cop
    module RootCops
      class UseEnvvars < RuboCop::Cop::Base
        MSG = %(Use ENVVARS["..."] instead of ENV["..."].).freeze

        def on_send(node)
          receiver, method_name = *node
          _, name = *receiver

          if name == :ENV && method_name == :[]
            add_offense(node.loc.expression, message: MSG)
          end
        end
      end
    end
  end
end
