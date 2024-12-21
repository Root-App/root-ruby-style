module RootCops
  class NoTracers < ::RuboCop::Cop::Cop
    MSG = "Remove all `Tracer` occurrences".freeze

    def_node_matcher :tracer, <<-PATTERN
      (send (const _ :Tracer) _)
    PATTERN

    def on_send(node)
      add_offense(node, location: :selector) if tracer(node)
    end
  end
end
