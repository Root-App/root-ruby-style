module RootCops
  class RaiseI18n < ::RuboCop::Cop::Cop
    MESSAGE = "Use raise with I18n instead of hard-coded strings".freeze

    def on_send(node)
      return unless node.command?(:raise)

      node.child_nodes.each do |child|
        add_offense(child, :expression, MESSAGE) if _str?(child)
      end
    end

    private

    def _str?(node)
      node.str_type? || node.dstr_type? || node.xstr_type?
    end
  end
end
