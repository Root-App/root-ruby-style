module RootCops
  class NoTracers < ::RuboCop::Cop::Base
    MSG = "Remove all `Tracer` occurrences".freeze

    def_node_matcher :tracer, <<-PATTERN
      (send (const _ :Tracer) _)
    PATTERN

    def on_send(node)
      add_offense(node.loc.selector) if tracer(node)
    end
  end
end
