module RootCops
  class NoTracers < ::RuboCop::Cop::Cop
    MSG = "Remove all `Tracer` occurrences".freeze

    def_node_matcher :trace_method, <<-PATTERN
      (send (const _ :Tracer) :trace_method)
    PATTERN

    def on_send(node)
      add_offense(node, :location => :selector) if trace_method(node)
    end
  end
end
