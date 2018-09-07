module RootCops
  module PrivateMethods
    class UnderscorePrefix < ::RuboCop::Cop::Cop
      NEED_UNDERSCORE = "Prefix private method names with an underscore. If method should be public, move it above the private scope.".freeze
      NEED_PRIVATE = "Include a private declaration above the private methods.".freeze

      def_node_matcher :visibility_block?, <<-PATTERN
        (send nil? { :private :protected :public })
      PATTERN

      def on_class(node)
        _name, _base_class, body = *node
        return unless body

        body_nodes = body.type == :begin ? body.children : [body]

        body_nodes.each do |child_node|
          _check_for_access_modifier(child_node) ||
            _check_for_instance_method(child_node)
        end
      end

      private

      def _check_for_instance_method(node)
        return unless node.def_type?
        method_name, *_args = *node
        if method_name =~ /^_/ && !@visibility
          add_offense(node, :location => :expression, :message => NEED_PRIVATE)
        end
        if method_name !~ /^_/ && @visibility
          add_offense(node, :location => :expression, :message => NEED_UNDERSCORE)
        end
      end

      def _check_for_access_modifier(node)
        return unless visibility_block?(node)
        _receiver, method_name = *node
        @visibility = method_name
      end
    end
  end
end
