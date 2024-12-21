module RootCops
  class EqBeEql < ::RuboCop::Cop::Cop
    MSG = "Prefer `eq` over `be` and `eql` when checking booleans, numbers, symbols, strings and nil".freeze

    def_node_matcher :be_or_eql, <<-PATTERN
      (send _ {:to :to_not :not_to} $(send nil? {:be :eql} {true false int float sym nil_type? str_type?}))
    PATTERN

    def_node_matcher :be_true_false_nil, <<-PATTERN
      (send _ {:to :to_not :not_to} $(send nil? {:be_true :be_false :be_nil}))
    PATTERN

    # This node matcher will match any attempt to use eql with any single variable
    # It is not smart enough to filter out vars that point to objects which should use eql
    # Therefore, it is currently not used in on_send below.
    def_node_matcher :eql_var, <<-PATTERN
      (send _ {:to :to_not :not_to} $(send nil? {:be :eql} (send nil? _)))
    PATTERN

    def on_send(node)
      be_or_eql(node) do |offending_node|
        add_offense(offending_node, location: :selector)
      end

      be_true_false_nil(node) do |offending_node|
        add_offense(offending_node, location: :selector)
      end
    end
  end
end
