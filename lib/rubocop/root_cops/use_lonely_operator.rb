module RootCops
  class UseLonelyOperator < ::RuboCop::Cop::Cop
    MSG = "Use the lonely operator foo&.bar instead of foo.try(:bar)".freeze

    def on_send(node)
      _receiver, method_name = *node
      if %I[try try!].include?(method_name)
        add_offense(node, :expression, MSG)
      end
    end
  end
end
