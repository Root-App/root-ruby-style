module RootCops
  class UseLonelyOperator < ::RuboCop::Cop::Cop
    MSG = "Use the lonely operator foo&.bar instead of foo.try(:bar)".freeze

    def on_send(node)
      _receiver, method_name = *node
      if %i[try try!].include?(method_name)
        add_offense(node, :location => :expression, :message => MSG)
      end
    end
  end
end
