module RootCops
  class UseEnvvars < ::RuboCop::Cop::Cop
    MSG = %(Use ENVVARS["..."] instead of ENV["..."].).freeze

    def on_send(node)
      receiver, method_name = *node
      _, name = *receiver

      if name == :ENV && method_name == :[]
        add_offense(node, :location => :expression, :message => MSG)
      end
    end
  end
end
