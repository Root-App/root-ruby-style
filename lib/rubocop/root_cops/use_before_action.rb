module RootCops
  class UseBeforeAction < ::RuboCop::Cop::Cop
    MSG = "Use #before_action instead of #before_filter.".freeze

    def on_send(node)
      _receiver, method_name = *node
      if method_name == :before_filter
        add_offense(node, :location => :expression, :message => MSG)
      end
    end
  end
end
