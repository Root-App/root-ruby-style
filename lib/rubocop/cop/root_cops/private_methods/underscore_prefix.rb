module RuboCop
  module Cop
    module RootCops
      module PrivateMethods
        class UnderscorePrefix < Cop
          NEED_UNDERSCORE = "Prefix private method names with an underscore. If method should be public, move it above the private scope.".freeze
          NEED_PRIVATE = "Include a private declaration above the private methods.".freeze

          def_node_matcher :visibility_block?, <<-PATTERN
            (send nil? { :private :protected :public })
          PATTERN

          def on_class(node)
            @visible = true

            _name, _base_class, body = *node
            return unless body

            _check_body(body)
          end

          def on_module(node)
            @visible = true

            _name, body = *node
            return unless body

            _check_body(body)
          end

          private

          def _check_body(body)
            body_nodes = body.type == :begin ? body.children : [body]

            body_nodes.each do |child_node|
              _check_for_access_modifier(child_node) || _check_for_instance_method(child_node)
            end
          end

          def _check_for_instance_method(node)
            method_name = nil

            if node.def_type?
              method_name, *_args = *node
            elsif node.defs_type?
              _self, method_name, *_args = *node
            end

            return if method_name.nil?

            if method_name =~ /^_/ && @visible
              add_offense(node, :location => :expression, :message => NEED_PRIVATE)
            end
            if method_name !~ /^_/ && !@visible
              add_offense(node, :location => :expression, :message => NEED_UNDERSCORE)
            end
          end

          def _check_for_access_modifier(node)
            return unless visibility_block?(node)

            _receiver, method_name = *node
            @visible = method_name == :public
          end
        end
      end
    end
  end
end
